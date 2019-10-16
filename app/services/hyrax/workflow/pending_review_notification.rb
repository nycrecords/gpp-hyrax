# frozen_string_literal: true

module Hyrax
  module Workflow
    class PendingReviewNotification < GppNotification
      def workflow_recipients
        { to: library_reviewers << depositor }
      end

      def subject
        'Deposit needs review'
      end

      def message
        "#{title} (#{link_to work_id, document_path}) was deposited by #{user.user_key} and is awaiting approval #{comment}"
      end
    end
  end
end