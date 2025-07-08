class CreateMandatedReportEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :mandated_report_events do |t|
      t.references :required_report, foreign_key: true
      t.references :user, foreign_key: true
      t.string :event_type, null: false
      t.jsonb :previous_value
      t.jsonb :new_value

      t.timestamps
    end
  end
end
