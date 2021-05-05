class AddAutomatedDateToRequiredReports < ActiveRecord::Migration[5.1]
  def change
    add_column :required_reports, :automated_date, :boolean, null: false, default: false
  end
end
