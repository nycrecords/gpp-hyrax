class ReportRequestWorker
  include Sidekiq::Worker

  def perform(*args)
    calendar = Rails.configuration.calendar
    today = Date.today
    user = User.first

    # Do not proceed if today is not a business day
    return unless calendar.business_day?(today)

    late_date = calendar.subtract_business_days(today, 10)
    late_reports = RequiredReportDueDate.includes(required_report: :agency)
                                        .where(date_submitted: nil, delinquency_report_published_date: nil)
                                        .where('due_date < ?', late_date)

    late_reports.each do |report|
      required_report_due_date = report
      required_report = required_report_due_date.required_report
      agency = required_report.agency

      # Create PDF
      pdf = ApplicationController.new.render_to_string(template: 'report_request_mailer/notice.pdf.erb',
                                                       locals: { :@required_report_due_date => required_report_due_date,
                                                                 :@required_report => required_report,
                                                                 :@agency => agency },
                                                       layout: 'application.pdf')

      f = File.new('testfile.pdf', 'w')
      f.write(pdf)
      uploaded_file = Hyrax::UploadedFile.create(user: user, file: pdf)
      f.close

      work = NycGovernmentPublication.new
      actor = Hyrax::CurationConcern.actor
      attributes = { uploaded_files: [uploaded_file.id.to_s],
                     title: [format('Delinquency Notice - %s', required_report.name)],
                     agency: agency.name,
                     description: [required_report.description],
                     report_type: 'Delinquent Report Notice',
                     subject: ['Compliance'],
                     date_published: today.to_s,
                     calendar_year: [today.year.to_s],
                     language: ['English'],
                     member_of_collections_attributes: { '0' => { id: 'fn106x926', _destroy: 'false' } } }
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

        # Send email notice of late report
        ReportRequestMailer.email(agency, pdf).deliver

        # Set delinquency_report_published_date to current datetime
        report.update_attributes(delinquency_report_published_date: Time.current)
      end
    end
  end
end
