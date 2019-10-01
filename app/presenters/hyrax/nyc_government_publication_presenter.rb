# frozen_string_literal: true

# Generated via
#  `rails generate hyrax:work NycGovernmentPublication`
module Hyrax
  class NycGovernmentPublicationPresenter < Hyrax::WorkShowPresenter
    delegate :sub_title,
             :report_type,
             :date_published,
             :fiscal_year,
             :calendar_year,
             :agency,
             :additional_creators,
             :borough,
             :school_district,
             :community_board_district,
             :associated_place,
             to: :solr_document
  end
end
