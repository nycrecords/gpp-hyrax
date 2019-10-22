class CreateRequiredReports < ActiveRecord::Migration[5.1]
  def change
    create_table :required_reports do |t|
      t.string :title
      t.string :agency
      t.string :frequency
      t.date :due_date
      t.string :citation

      t.timestamps
    end
  end
end
