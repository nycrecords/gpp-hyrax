class ReportRequestWorker
  include Sidekiq::Worker

  def perform(*args)
    calendar = Rails.configuration.calendar
    today = Date.today

    if calendar.business_day?(today)
      late_date = calendar.subtract_business_days(today, 10)
      late_reports = RequiredReportDueDate.includes(required_report: :agency)
                                          .where(date_submitted: nil, delinquency_report_published_date: nil)
                                          .where('due_date < ?', late_date)

      late_reports.each do |report|
        required_report = late_reports.required_report
        agency = required_report.agency

        ReportRequestMailer.email(agency.point_of_contact_emails).deliver

        report.delinquency_report_published_date = Time.current
      end
    end
  end
end
