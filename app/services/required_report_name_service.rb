module RequiredReportNameService
  def self.select_all_options
    required_reports = RequiredReportDueDate.includes(:required_report)
                                            .order('required_reports.name ASC, base_due_date ASC')
                                            .references(:required_reports)

    required_reports = required_reports.all.map do |report|
      [report.required_report.name + ' (' + report.base_due_date.to_s + ')', report.required_report.name]
    end

    required_reports << ['Other Publication', 'Other Publication']
  end
end