# frozen_string_literal: true

module Hyrax
  module Workflow
    class DepositedNotification < GppNotification
      def workflow_recipients
        { to: library_reviewers << depositor }
      end

      def subject
        'Deposit has been approved'
      end

      def message
        "#{title} (#{link_to work_id, document_path}) was approved by #{user.user_key}. #{comment}"
      end
    end
  end
end