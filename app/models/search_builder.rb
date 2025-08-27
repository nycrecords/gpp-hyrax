# frozen_string_literal: true
class SearchBuilder < Blacklight::SearchBuilder
  include Blacklight::Solr::SearchBuilderBehavior
  include BlacklightAdvancedSearch::AdvancedSearchBuilder
  include Gpp::SearchFilters
  self.default_processor_chain += [
    :add_advanced_parse_q_to_solr,
    :add_advanced_search_to_solr,
    :exclude_suppressed_late_notices,
    :filter_late_notices
  ]

  include Hydra::AccessControlsEnforcement
  include Hyrax::SearchFilters


  ##
  # @example Adding a new step to the processor chain
  #   self.default_processor_chain += [:add_custom_data_to_query]
  #
  #   def add_custom_data_to_query(solr_parameters)
  #     solr_parameters[:custom] = blacklight_params[:user_value]
  #   end
end