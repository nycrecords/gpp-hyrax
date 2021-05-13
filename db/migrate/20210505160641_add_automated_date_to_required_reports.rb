class AddAutomatedDateToRequiredReports < ActiveRecord::Migration[5.1]
  def change
    add_column :required_reports, :automated_date, :boolean, null: false, default: true
    rename_column :required_report_due_dates, :due_date, :base_due_date

    # Set grace_due_date to base_due_date
    add_column :required_report_due_dates, :grace_due_date, :date
    RequiredReportDueDate.find_each do |rr|
      rr.update_attributes!(:grace_due_date => rr.base_due_date)
    end

    change_column_null :required_report_due_dates, :grace_due_date, false
  end
end
