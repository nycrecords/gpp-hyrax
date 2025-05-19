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
             :required_report_name, to: :solr_document

    def formatted_required_report_name
      report_name = required_report_name&.first
      report_name = 'Other Publication' if report_name == 'Not Required'

      if show_base_due_date?
        base_due_date = required_report_base_due_date&.base_due_date
        report_name += " (Due Date: #{base_due_date})" if base_due_date.present?
      end

      report_name
    end

    def show_base_due_date?
      user = current_ability.try(:current_user)
      user&.admin? || user&.library_reviewers?
    end

    def required_report_base_due_date
      @required_report_base_due_date ||= RequiredReportDueDate.find_by(submission_id: id) ||
                                    RequiredReportDueDate.find_by(delinquency_report_id: id)
    end
  end
end