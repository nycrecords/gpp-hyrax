class AddFieldsToRequiredReports < ActiveRecord::Migration[5.2]
  def change
    add_column :required_reports, :required_distribution, :string
    add_column :required_reports, :report_deadline, :string
    add_column :required_reports, :additional_notes, :text
  end
end
