class ReportRequestWorker
  include Sidekiq::Worker

  def perform(*args)
    calendar = Rails.configuration.calendar
    today = Date.today
    user = User.find_by(email: ENV['LIBRARY_USER_EMAIL'])

    # Do not proceed if today is not a business day
    return unless calendar.business_day?(today)

    late_date = calendar.subtract_business_days(today, 11)
    late_reports = RequiredReportDueDate.includes(required_report: :agency)
                                        .where(date_submitted: nil, delinquency_report_published_date: nil)
                                        .where('grace_due_date < ?', late_date)
    failed_reports = {}
    late_reports.each do |report|
      required_report_due_date = report
      required_report = required_report_due_date.required_report
      agency = required_report.agency

      # Generate PDF and handle exception if render fails
      begin
        pdf = ApplicationController.new.render_to_string(template: 'report_request_mailer/notice.pdf.erb',
                                                         locals: { :@required_report_due_date => required_report_due_date,
                                                                   :@required_report => required_report,
                                                                   :@agency => agency },
                                                         layout: 'application.pdf')
      rescue ActionView::Template::Error => e
        failed_reports[required_report_due_date.id] = { name: required_report.name,
                                                        error: e.message }
        next
      end

      f = Tempfile.new([format('%s_report_request', required_report.id.to_s), '.pdf'])
      f.write(pdf)
      uploaded_file = Hyrax::UploadedFile.create(user: user, file: f)
      f.close
      f.unlink

      work = NycGovernmentPublication.new
      actor = Hyrax::CurationConcern.actor
      attributes = { uploaded_files: [uploaded_file.id.to_s],
                     title: [format('Late Notice - %s', required_report.name)],
                     agency: agency.name,
                     required_report_name: required_report.name,
                     description: [required_report.description],
                     report_type: 'Delinquent Report Notice',
                     subject: ['Compliance'],
                     date_published: today.to_s,
                     calendar_year: [today.year.to_s],
                     language: ['English'],
                     member_of_collections_attributes: { '0' => {
                       id: Collection.where(title: 'Government Publication').first.id,
                       _destroy: 'false'
                     } } }
      actor_environment = Hyrax::Actors::Environment.new(work, user.ability, attributes)
      status = actor.create(actor_environment)

      if status
        approve_attributes = { name: 'approve', comment: '' }
        workflow_action_form = Hyrax::Forms::WorkflowActionForm.new(
          current_ability: user.ability,
          work: work,
          attributes: approve_attributes
        )
        workflow_action_form.save
        work.visibility = Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC
        work.save!
        VisibilityCopyJob.perform_later(work)
        InheritPermissionsJob.perform_later(work)
        
        # Send email notice of late report
        ReportRequestMailer.email(agency, pdf).deliver

        # Set delinquency_report_id and delinquency_report_published_date
        report.update_attributes(delinquency_report_id: work.id,
                                 delinquency_report_published_date: Time.current)
      else
        failed_reports[required_report_due_date.id] = { name: required_report.name,
                                                        error: work.errors.full_messages.join(' ') }
      end
    end

    ReportRequestMailer.failure_email(failed_reports).deliver unless failed_reports.empty?
  end
end
