class Hyrax::CatalogSearchBuilder < Hyrax::SearchBuilder
  include Blacklight::Solr::SearchBuilderBehavior
  include BlacklightAdvancedSearch::AdvancedSearchBuilder
  include Hydra::AccessControlsEnforcement
  include Hyrax::SearchFilters
  self.default_processor_chain += [
    :add_advanced_parse_q_to_solr,
    :add_advanced_search_to_solr,
    :add_highlighting_to_file_text,
    :show_works_that_contain_files,
  ]

  def show_works_that_contain_files(solr_parameters)
    return unless blacklight_params[:search_field] == 'advanced'

    # Don't overwrite if add_advanced_search_to_solr already handled
    return if solr_parameters[:q].present?

    user_query = blacklight_params[:q] || blacklight_params[:all_fields]
    return if user_query.blank?

    solr_parameters[:user_query] = user_query
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

  def add_highlighting_to_file_text(solr_parameters)
    return unless blacklight_params[:search_field] == "all_fields" || blacklight_params[:all_fields].present?
    solr_parameters[:hl] = true
    solr_parameters[:'hl.fl'] = 'all_text_timv'
    solr_parameters[:'hl.method'] = 'unified'
    solr_parameters[:'hl.requireFieldMatch'] = true
    solr_parameters[:'hl.weightMatches'] = true
    solr_parameters[:'hl.simple.pre'] = '<em class="search-highlight">'
    solr_parameters[:'hl.simple.post'] = '</em>'
    solr_parameters[:'hl.fragsize'] = ENV.fetch('SOLR_FRAGSIZE', 100).to_i
    solr_parameters[:'hl.snippets'] = ENV.fetch('SOLR_SNIPPETS', 1).to_i
    solr_parameters[:'hl.maxAnalyzedChars'] = ENV.fetch('SOLR_MAX_ANALYZED_CHARS', 51200).to_i
  end
end