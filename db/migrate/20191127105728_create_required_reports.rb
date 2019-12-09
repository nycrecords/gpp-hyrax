class CreateRequiredReports < ActiveRecord::Migration[5.1]
  def change
    create_table :required_reports do |t|
      t.string :agency_name, null: false
      t.string :name, null: false
      t.string :description
      t.string :local_law
      t.string :charter_and_code
      t.string :frequency
      t.integer :frequency_integer
      t.string :other_frequency_description
      t.date :start_date
      t.date :end_date
      t.date :last_published_date

      t.timestamps
    end

    add_foreign_key :required_reports, :agencies, column: :agency_name, primary_key: 'name'
  end
end
