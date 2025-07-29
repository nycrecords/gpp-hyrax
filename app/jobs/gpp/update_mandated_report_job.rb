# frozen_string_literal: true
module Gpp
  class UpdateMandatedReportJob < ApplicationJob
    queue_as :default

    def perform(work_id, workflow_action_name)
      work = NycGovernmentPublication.find(work_id)
      required_report_name = work.required_report_name
      date_published = Date.parse(work.date_published)
      required_report = RequiredReport
                          .where(agency_name: work.agency, name: required_report_name)
                          .find_by(end_date: nil) || RequiredReport.where(agency_name: work.agency, name: required_report_name).first
      due_date = RequiredReportDueDate.find_by(submission_id: work.id)

      case workflow_action_name
        when 'comment_only'
          return
        when 'approve'
          # Set last_published_date if work is approved and date_published is after the current value of last_published_date
          if required_report.last_published_date.nil? || (date_published > required_report.last_published_date)
            required_report.update(last_published_date: date_published)
          end
          # Suppress late notice in search results if generated
          delinquency_id = due_date&.delinquency_report_id
          Gpp::UpdateLateNoticeSuppressionJob.perform_later(true, delinquency_id) if delinquency_id.present?
        when 'request_changes'
          # Set date_submitted to nil on request_changes
          RequiredReportDueDate.where(submission_id: work.id).first&.update(date_submitted: nil)
        when 'request_review'
          # Set date_submitted to the current date and time on request_review
          RequiredReportDueDate.where(submission_id: work.id).first&.update(date_submitted: Time.current)
      else
        return
      end
    end
  end
end
