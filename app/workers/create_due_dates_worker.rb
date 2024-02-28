class CreateDueDatesWorker
  include Sidekiq::Worker

  def perform(*args)
    current_date = DateTime.current.to_date
    required_reports = RequiredReport.where.not(start_date: nil)
                         .where(automated_date: true)
                         .where("end_date is null OR end_date >= ?", current_date)
    required_reports.each do |rr|
      # Get most recent year to determine start_date and calculate future due dates
      rr_due_date = RequiredReportDueDate.where(required_report_id: rr.id).order(base_due_date: :desc).first

      latest_year = rr_due_date.nil? ? rr.start_date.year : rr_due_date.base_due_date.year
      # Skip to next required report if due dates already exist for current year
      next if (latest_year - current_date.year) > 0

      # Use RequiredReport start date if there is no RequiredReportDueDate
      start_date_month = rr_due_date.nil? ? rr.start_date.month : rr_due_date.base_due_date.month
      start_date_day = rr_due_date.nil? ? rr.start_date.day : rr_due_date.base_due_date.day

      # Create new start date for RequiredReportDueDate due date calculations
      start_date = Date.new(latest_year, start_date_month, start_date_day)
      due_date_attributes = RequiredReportDueDate.new.generate_due_date_attributes(rr.frequency,
                                                                                   rr.frequency_integer,
                                                                                   start_date,
                                                                                   rr.end_date,
                                                                                   rr.automated_date)

      # Create new RequiredReportDueDate if there is no existing row with the base_due_date
      due_date_attributes.each do |due_date|
        next if RequiredReportDueDate.where(required_report_id: rr.id, base_due_date: due_date[:base_due_date]).exists?

        RequiredReportDueDate.create(required_report_id: rr.id,
                                     base_due_date: due_date[:base_due_date],
                                     grace_due_date: due_date[:grace_due_date])
      end
    end
  end
end
