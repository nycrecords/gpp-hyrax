class ReportRequestWorker
  include Sidekiq::Worker

  def perform(*args)
    calendar = Rails.configuration.calendar
    today = Date.today

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
      pdf = WickedPdf.new.pdf_from_string(
        ApplicationController.new.render_to_string(template: 'report_request_mailer/notice.html.erb',
                                                   locals: { :@required_report_due_date => required_report_due_date,
                                                             :@required_report => required_report,
                                                             :@agency => agency },
                                                   layout: 'pdf.html')
      )

      # Send email notice of late report
      ReportRequestMailer.email(agency, pdf).deliver

      # Set delinquency_report_published_date to current datetime
      report.update_attributes(delinquency_report_published_date: Time.current)
    end
  end
end
