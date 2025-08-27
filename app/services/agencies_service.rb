module AgenciesService
  mattr_accessor :authority
  self.authority = Qa::Authorities::Local.subauthority_for('agencies')

  def self.select_all_options
    authority.all.map do |element|
      [element[:label], element[:id]]
    end
  end

  def self.label(id)
    authority.find(id).fetch('term')
  end

  def self.aliases_for(agency_name)
    return [] unless agency_name.present?

    primary_agency = Agency.find_by(name: agency_name)
    return [] unless primary_agency

    ([primary_agency.name] + primary_agency.aliases.pluck(:name)).uniq - [agency_name]
  end
end
