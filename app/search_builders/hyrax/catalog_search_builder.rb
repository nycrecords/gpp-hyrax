class Hyrax::CatalogSearchBuilder < Hyrax::SearchBuilder
  include Blacklight::Solr::SearchBuilderBehavior
  include BlacklightAdvancedSearch::AdvancedSearchBuilder
  include Hydra::AccessControlsEnforcement
  include Hyrax::SearchFilters
  self.default_processor_chain += [:add_advanced_parse_q_to_solr, :add_advanced_search_to_solr]
end