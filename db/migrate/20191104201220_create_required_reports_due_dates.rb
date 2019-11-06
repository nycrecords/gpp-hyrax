class CreateRequiredReportsDueDates < ActiveRecord::Migration[5.1]
  def change
    create_table :required_reports_due_dates do |t|
      t.references :required_report, foreign_key: { to_table: :required_reports }, index: true, null: false
      t.date :due_date, null: false
      t.datetime :date_submitted
      t.datetime :delinquency_report_published_date

      t.timestamps
    end
  end
end
