class Hyrax::CatalogSearchBuilder < Hyrax::SearchBuilder
  include Blacklight::Solr::SearchBuilderBehavior
  include BlacklightAdvancedSearch::AdvancedSearchBuilder
  include Hydra::AccessControlsEnforcement
  include Hyrax::SearchFilters
  self.default_processor_chain += [
    :add_advanced_parse_q_to_solr,
    :add_advanced_search_to_solr,
    :show_works_that_contain_files
  ]

  def show_works_that_contain_files(solr_parameters)
    if blacklight_params[:search_field] == 'advanced' && blacklight_params[:all_fields].present?
      return if solr_parameters[:q].blank?

      advanced_all_fields_query = advanced_all_fields_query(blacklight_params[:all_fields])
      solr_parameters[:q] += advanced_all_fields_query
      return
    end

    # Handle regular search
    return if blacklight_params[:q].blank? || blacklight_params[:search_field] != 'all_fields'
    solr_parameters[:user_query] = blacklight_params[:q]
    solr_parameters[:q] = new_query
    solr_parameters[:defType] = 'lucene'
  end

  private

  # the {!lucene} gives us the OR syntax
  def new_query
    "{!lucene}#{internal_query(dismax_query)} #{internal_query(join_for_works_from_files)}"
  end

  # the _query_ allows for another parser (aka dismax)
  def internal_query(query_value)
    "_query_:\"#{query_value}\""
  end

  # the {!dismax} causes the query to go against the query fields
  def dismax_query
    "{!dismax v=$user_query}"
  end

  # join from file id to work relationship solrized file_set_ids_ssim
  def join_for_works_from_files
    "{!join from=#{ActiveFedora.id_field} to=file_set_ids_ssim}#{dismax_query}"
  end

  def advanced_all_fields_query(all_fields_value)
    " _query_:\"{!join from=#{ActiveFedora.id_field} to=file_set_ids_ssim}""{!dismax qf=all_text_timv}#{all_fields_value}\""
  end
end