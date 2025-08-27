class AgencyAlias < ApplicationRecord
  belongs_to :primary_agency, class_name: 'Agency'
  belongs_to :alias_agency, class_name: 'Agency'

  validates :primary_agency_id, presence: true
  validates :alias_agency_id, presence: true
  validates :alias_agency_id, uniqueness: { scope: :primary_agency_id }
  validate :prevent_self_alias

  after_create :create_inverse_alias
  after_destroy :destroy_inverse_alias

  private

  def create_inverse_alias
    unless AgencyAlias.exists?(primary_agency: alias_agency, alias_agency: primary_agency)
      AgencyAlias.create!(primary_agency: alias_agency, alias_agency: primary_agency)
    end
  end

  def prevent_self_alias
    if primary_agency_id == alias_agency_id
      errors.add(:alias_agency_id, "cannot be the same as primary_agency_id")
    end
  end

  def destroy_inverse_alias
    inverse = AgencyAlias.find_by(primary_agency: alias_agency, alias_agency: primary_agency)
    inverse&.destroy
  end
end
