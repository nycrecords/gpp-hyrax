class CreateDueDatesWorker
  include Sidekiq::Worker

  def perform(*args)
    current_date = DateTime.new(2023, 1, 1, 0, 0, 0)
    required_reports = RequiredReport.where.not(start_date: nil)
                         .where(automated_date: true)
                         .where("end_date is null OR end_date >= ?", current_date)
    required_reports.each do |rr|
      # Get most recent year to determine start_date and calculate future due dates
      latest_year = RequiredReportDueDate.where(required_report_id: rr.id).order(base_due_date: :desc).first.base_due_date.year
      return unless (latest_year - current_date.year) <= 1

      start_date_month = rr.start_date.month
      start_date_day = rr.start_date.day

      start_date = Date.new(latest_year, start_date_month, start_date_day)
      due_date_attributes = RequiredReportDueDate.new.generate_due_date_attributes(rr.frequency,
                                                                                   rr.frequency_integer,
                                                                                   start_date,
                                                                                   rr.end_date,
                                                                                   rr.automated_date)
      due_date_attributes.each do |due_date|
        RequiredReportDueDate.find_or_create_by(required_report_id: rr.id,
                                                base_due_date: due_date[:base_due_date],
                                                grace_due_date: due_date[:grace_due_date])
      end
    end
  end
end
