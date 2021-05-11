class AddAutomatedDateToRequiredReports < ActiveRecord::Migration[5.1]
  def change
    add_column :required_reports, :automated_date, :boolean, null: false, default: false
    add_column :required_report_due_dates, :grace_due_date, :date, null: false
    rename_column :required_report_due_dates, :due_date, :base_due_date
  end
end
