class AddDelinquencyReportIdToRequiredReportDueDates < ActiveRecord::Migration[5.1]
  def change
    add_column :required_report_due_dates, :delinquency_report_id, :string
  end
end
