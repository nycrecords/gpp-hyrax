# frozen_string_literal: true
# [gpp-override] Add email notification after job completion

module Bulkrax
  class ScheduleRelationshipsJob < ApplicationJob

    after_perform do |job|
      importer = Importer.find(job.arguments.first[:importer_id])
      file_path = importer.parser_fields['import_file_path']
      file_name = File.basename(file_path)
      pending_num = importer.entries.left_outer_joins(:latest_status)
                            .where('bulkrax_statuses.status_message IS NULL ').count

      if pending_num.zero?
        BulkImportMailer.email(importer, file_name).deliver_now
        cleanup_imported_file(importer.id, file_path)
      end
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

    def cleanup_imported_file(importer_id, file_path)
      zip_file_dir = File.dirname(file_path)
      import_dir = File.join(Bulkrax.import_path, "import_#{File.basename(zip_file_dir)}_#{importer_id}")

      begin
        Rails.logger.info("Cleaning up imported files: #{zip_file_dir}, #{import_dir}")
        FileUtils.rm_rf([zip_file_dir, import_dir])
        Rails.logger.info("Cleanup successful.")
      rescue StandardError => e
        Rails.logger.error("Error during cleanup: #{e.message}")
      end
    end
  end
end
