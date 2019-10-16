# frozen_string_literal: true

module Hyrax
  module Workflow
    class PendingReviewNotification < GppNotification
      def workflow_recipients
        { to: library_reviewers << depositor }
      end

      def subject
        'You have a new task'
      end

      def message
        "A new item has been submitted:<br><br>" +
            "Title: #{title}<br>" +
            "Submitted by: #{user.display_name} (#{user.user_key})<br><br>" +
            "The submission must be checked before inclusion in the archive.<br><br>" +
            "To review this submission, please visit: #{link_to work_id, document_url}"
      end
    end
  end
end
