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
        ReportRequestMailer.email(report).deliver

        report.delinquency_report_published_date = Time.current
      end
    end
  end
end
