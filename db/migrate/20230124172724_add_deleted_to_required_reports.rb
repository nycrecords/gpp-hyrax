class AddDeletedToRequiredReports < ActiveRecord::Migration[5.2]
  def change
    add_column :required_reports, :deleted, :boolean
  end
end
