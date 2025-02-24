# Generated via
#  `rails generate hyrax:work NycGovernmentPublication`
class NycGovernmentPublication < ActiveFedora::Base
  include Hyrax::WorkBehavior
  self.human_readable_type = 'NYC Government Publication'

  self.indexer = NycGovernmentPublicationIndexer
  # Change this to restrict which works can be added as a child.
  # self.valid_child_concerns = []
  validates :title, presence: { message: 'Your work must have a title.' }

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

  # This must be included at the end, because it finalizes the metadata
  # schema (by adding accepts_nested_attributes)
  include ::Hyrax::BasicMetadata
end
