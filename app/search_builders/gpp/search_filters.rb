# frozen_string_literal: true
module Gpp
  module SearchFilters

    # Allow only admins or library staff to see suppressed late notices
    def exclude_suppressed_late_notices(solr_parameters)
      return if authorized?
      solr_parameters[:fq] ||= []
      solr_parameters[:fq] << '-suppressed_late_notice_bsi:true'
    end

    # Apply a negative boost to late notices so they appear at the end of search results
    def filter_late_notices(solr_parameters)
      solr_parameters[:bq] ||= ''
      solr_parameters[:bq] += 'late_notice_bsi:true^-10'
    end

    def add_highlighting_to_file_text(solr_parameters)
      return unless blacklight_params[:search_field] == "all_fields" || blacklight_params[:all_fields].present?
      solr_parameters[:hl] = true
      solr_parameters[:'hl.fl'] = 'all_text_timv'
      solr_parameters[:'hl.method'] = ENV.fetch('SOLR_METHOD', 'original')
      solr_parameters[:'hl.bs.type'] = ENV.fetch('SOLR_BS_TYPE', 'WORD')
      solr_parameters[:'hl.requireFieldMatch'] = true
      solr_parameters[:'hl.weightMatches'] = true
      solr_parameters[:'hl.simple.pre'] = '<em class="search-highlight">'
      solr_parameters[:'hl.simple.post'] = '</em>'
      solr_parameters[:'hl.fragsize'] = ENV.fetch('SOLR_FRAGSIZE', 100).to_i
      solr_parameters[:'hl.snippets'] = ENV.fetch('SOLR_SNIPPETS', 1).to_i
      solr_parameters[:'hl.maxAnalyzedChars'] = ENV.fetch('SOLR_MAX_ANALYZED_CHARS', 51200).to_i
    end

    private

    def authorized?
      ability = scope.current_ability
      ability.admin? || ability.current_user&.library_reviewers?
    end
  end
end
