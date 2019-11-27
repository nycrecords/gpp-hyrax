class RequiredReport < ApplicationRecord
  has_many :required_report_due_dates
  belongs_to :agency, foreign_key: 'agency_name', primary_key: 'name'

  # Convert empty name and agency fields to null
  nilify_blanks only: [:name, :agency]
end
