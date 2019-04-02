module NycGovernmentPublicationMetadata
  extend ActiveSupport::Concern

  included do
    property :title, predicate: ::RDF::Vocab::DC.title do |index|
      index.as :stored_searchable, :facetable
    end

    property :sub_title, predicate: ::RDF::Vocab::DC.alternative, multiple: true do |index|
      index.as :stored_searchable, :facetable
    end

    property :agency, predicate: ::RDF::Vocab::DC.creator do |index|
      index.as :stored_searchable, :facetable
    end

    property :additional_creators, predicate: ::RDF::Vocab::DC.contributor, multiple: true do |index|
      index.as :stored_searchable, :facetable
    end

    property :subject, predicate: ::RDF::Vocab::DC.subject, multiple: true do |index|
      index.as :stored_searchable, :facetable
    end

    property :description, predicate: ::RDF::Vocab::DC.abstract do |index|
      index.as :stored_searchable, :facetable
    end

    property :date_issued, predicate: ::RDF::Vocab::DC.issued do |index|
      index.as :stored_searchable, :facetable
    end

    property :type, predicate: ::RDF::Vocab::DC.type do |index|
      index.as :stored_searchable, :facetable
    end

    property :language, predicate: ::RDF::Vocab::DC.language, multiple: true do |index|
      index.as :stored_searchable, :facetable
    end

    property :fiscal_year, predicate: ::RDF::Vocab::DC.temporal, multiple: true do |index|
      index.as :stored_searchable, :facetable
    end

    property :calendar_year, predicate: ::RDF::Vocab::DC.temporal, multiple: true do |index|
      index.as :stored_searchable, :facetable
    end

    property :borough, predicate: ::RDF::Vocab::DC.spatial, multiple: true do |index|
      index.as :stored_searchable, :facetable
    end

    property :school_district, predicate: ::RDF::Vocab::DC.spatial, multiple: true do |index|
      index.as :stored_searchable, :facetable
    end

    property :community_board_district, predicate: ::RDF::Vocab::DC.spatial, multiple: true do |index|
      index.as :stored_searchable, :facetable
    end

    property :associated_place, predicate: ::RDF::Vocab::DC.spatial, multiple: true do |index|
      index.as :stored_searchable, :facetable
    end
  end
end