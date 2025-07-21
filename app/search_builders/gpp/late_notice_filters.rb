# frozen_string_literal: true
module Gpp
  module LateNoticeFilters

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

    private

    def authorized?
      ability = scope.current_ability
      ability.admin? || ability.current_user&.library_reviewers?
    end
  end
end
