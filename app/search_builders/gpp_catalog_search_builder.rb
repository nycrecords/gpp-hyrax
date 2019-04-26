class GppCatalogSearchBuilder < Hyrax::CatalogSearchBuilder
  include Blacklight::Solr::SearchBuilderBehavior
  include BlacklightAdvancedSearch::AdvancedSearchBuilder
  self.default_processor_chain += [:add_advanced_parse_q_to_solr, :add_advanced_search_to_solr]
  # Add a filter query to restrict the search to documents the current user has access to
  include Hydra::AccessControlsEnforcement
  include Hyrax::SearchFilters
  # Override default behavior so admin users can see unpublished works in the search results
  # def show_only_active_records(solr_parameters)
  #   solr_parameters[:fq] ||= []
  #   solr_parameters[:fq] << '-suppressed_bsi:true' unless current_user.admin?
  #   solr_parameters[:fq].delete("-suppressed_bsi:true") if current_user.admin?
  # end
end