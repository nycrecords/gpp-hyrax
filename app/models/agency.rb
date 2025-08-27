class Agency < ApplicationRecord
  has_many :required_reports, foreign_key: 'agency_name', primary_key: 'name'
  has_many :required_report_due_dates, through: :required_reports

  has_many :outgoing_aliases, class_name: 'AgencyAlias', foreign_key: 'primary_agency_id', dependent: :destroy
  has_many :incoming_aliases, class_name: 'AgencyAlias', foreign_key: 'alias_agency_id', dependent: :destroy

  has_many :aliases, through: :outgoing_aliases, source: :alias_agency
  has_many :aliased_by, through: :incoming_aliases, source: :primary_agency
end
