# frozen_string_literal: true
# [gpp-override] Add email notification after job completion

module Bulkrax
  class ScheduleRelationshipsJob < ApplicationJob

    after_perform do |job|
      importer = Importer.find(job.arguments.first[:importer_id])
      pending_num = importer.entries.left_outer_joins(:latest_status)
                            .where('bulkrax_statuses.status_message IS NULL ').count
      BulkImportMailer.email(importer).deliver_now if pending_num.zero?
    end

    def perform(importer_id:)
      importer = Importer.find(importer_id)
      pending_num = importer.entries.left_outer_joins(:latest_status)
                            .where('bulkrax_statuses.status_message IS NULL ').count
      return reschedule(importer_id) unless pending_num.zero?

      importer.last_run.parents.each do |parent_id|
        CreateRelationshipsJob.perform_later(parent_identifier: parent_id, importer_run_id: importer.last_run.id)
      end
    end

    def reschedule(importer_id)
      ScheduleRelationshipsJob.set(wait: 5.minutes).perform_later(importer_id: importer_id)
      false
    end
  end
end
