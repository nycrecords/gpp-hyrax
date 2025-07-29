# frozen_string_literal: true
module Gpp
  class DeletePublicationJob < ApplicationJob
    queue_as :default

    def perform(metadata, submission_id, agency, mandated_report_name, user_guid)
      # Query for publications with required_report
      publications = NycGovernmentPublication.where(agency: agency, required_report_name: mandated_report_name)
                                             .order('date_published_ssi desc')
      mandated_report = RequiredReport.where(agency_name: agency, name: mandated_report_name).first
      mandated_report_due_date = RequiredReportDueDate.where(submission_id: submission_id).first

      # Store deleted work's metadata in deleted_publications
      if metadata.present?
        metadata[:mandated_report_due_date_id] = mandated_report_due_date.id unless mandated_report_due_date.nil?
        DeletedPublication.create!(user_guid: user_guid, timestamp: Time.current, metadata: metadata)
      end

      if mandated_report.present?
        last_published_date_updated = false

        if publications.present?
          publications.each do |p|
            next if p.suppressed? ||
                    p.late_notice ||
                    ["Not Required", "Other Publication"].include?(p.required_report_name)

            mandated_report.update(last_published_date: p.date_published)
            last_published_date_updated = true
            break
          end
        end
        # Set last_published_date to nil if no previous publication exists
        mandated_report.update(last_published_date: nil) unless last_published_date_updated
      end

      # Set submission_id and date_submitted to nil in required_report_due_dates
      mandated_report_due_date&.update(submission_id: nil, date_submitted: nil)

      # Unsuppress late notice in search results if generated
      delinquency_id = mandated_report_due_date&.delinquency_report_id
      Gpp::UpdateLateNoticeSuppressionJob.perform_later(false, delinquency_id) if delinquency_id.present?
    end
  end
end
