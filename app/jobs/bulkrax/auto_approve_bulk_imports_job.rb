# frozen_string_literal: true

module Bulkrax
  class AutoApproveBulkImportsJob < ApplicationJob
    queue_as :import

    def perform(work:)
      @user = User.find_by(email: ENV['LIBRARY_USER_EMAIL'])
      approve_attributes = { name: 'approve', comment: ''}
      workflow_action_form = Hyrax::Forms::WorkflowActionForm.new(
        current_ability: @user.ability,
        work: work,
        attributes: approve_attributes,
      )
      workflow_action_form.save
    end
  end
end
