module NycGovernmentPublicationsMetadata
  extend ActiveSupport::Concern

  included do
    after_initialize :set_default_visibility
    def set_default_visibility
      self.visibility = Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC if new_record?
    end

    property :title, predicate: ::RDF::Vocab::DC.title do |index|
      index.as :stored_searchable, :facetable
    end

    property :sub_title, predicate: ::RDF::Vocab::DC.alternative, multiple: true do |index|
      index.as :stored_searchable, :facetable
    end

    property :agency, predicate: ::RDF::Vocab::DC.creator, multiple: false  do |index|
      index.as :stored_searchable, :facetable
    end

    property :required_report_name, predicate: ::RDF::URI.intern('http://a860-gpp.nyc.gov/required-report-name'), multiple: false do |index|
      index.as :stored_searchable, :facetable
    end

    property :additional_creators, predicate: ::RDF::Vocab::DC.contributor, multiple: true do |index|
      index.as :stored_searchable, :facetable
    end

    property :subject, predicate: ::RDF::Vocab::DC.subject, multiple: true do |index|
      index.as :stored_searchable, :facetable
    end

    property :description, predicate: ::RDF::Vocab::DC.abstract, multiple: false  do |index|
      index.as :stored_searchable, :facetable
    end

    property :date_published, predicate: ::RDF::Vocab::DC.issued, multiple: false  do |index|
      index.as :stored_searchable, :facetable
    end

    property :report_type, predicate: ::RDF::Vocab::DC.type, multiple: false  do |index|
      index.as :stored_searchable, :facetable
    end

    property :language, predicate: ::RDF::Vocab::DC.language, multiple: true do |index|
      index.as :stored_searchable, :facetable
    end

    property :fiscal_year, predicate: ::RDF::URI.intern('http://a860-gpp.nyc.gov/temporal-fiscal'), multiple: true do |index|
      index.as :stored_searchable, :facetable
    end

    property :calendar_year, predicate: ::RDF::URI.intern('http://a860-gpp.nyc.gov/temporal-calendar'), multiple: true do |index|
      index.as :stored_searchable, :facetable
    end

    property :borough, predicate: ::RDF::URI.intern('http://a860-gpp.nyc.gov/spatial-borough'), multiple: true do |index|
      index.as :stored_searchable, :facetable
    end

    property :school_district, predicate: ::RDF::URI.intern('http://a860-gpp.nyc.gov/spatial-school-district'), multiple: true do |index|
      index.as :stored_searchable, :facetable
    end

    property :community_board_district, predicate: ::RDF::URI.intern('http://a860-gpp.nyc.gov/spatial-community-board-district'), multiple: true do |index|
      index.as :stored_searchable, :facetable
    end

    property :associated_place, predicate: ::RDF::URI.intern('http://a860-gpp.nyc.gov/spatial-place'), multiple: true do |index|
      index.as :stored_searchable, :facetable
    end
  end
end