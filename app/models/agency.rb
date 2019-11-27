class Agency < ApplicationRecord
  has_many :required_reports, foreign_key: 'agency_name', primary_key: 'name'
  has_many :required_report_due_dates, through: :required_reports
end
