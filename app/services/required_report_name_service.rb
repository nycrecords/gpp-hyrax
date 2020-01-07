module RequiredReportNameService
  def self.select_all_options
    required_reports = RequiredReportDueDate.includes(:required_report)
                                            .order('required_reports.name ASC, due_date ASC')
                                            .references(:required_reports)

    required_reports = required_reports.all.map do |report|
      [report.required_report.name + ' (' + report.due_date.to_s + ')', report.required_report.name]
    end

    required_reports << ['Not Required', 'Not Required']
  end
end