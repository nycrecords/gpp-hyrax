class AddIsVisibleToRequiredReports < ActiveRecord::Migration[5.2]
  def change
    add_column :required_reports, :is_visible, :boolean, default: true, null: false
  end
end
