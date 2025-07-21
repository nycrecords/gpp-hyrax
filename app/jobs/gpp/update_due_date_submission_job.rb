# frozen_string_literal: true
module Gpp
  class UpdateDueDateSubmissionJob < ApplicationJob
    queue_as :default

    def perform(due_date_id, publication_id)
      due_date = RequiredReportDueDate.find(due_date_id)
      return unless due_date

      due_date.update(submission_id: publication_id, date_submitted: Time.current)
    end
  end
end
