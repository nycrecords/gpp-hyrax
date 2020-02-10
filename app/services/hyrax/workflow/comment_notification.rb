# frozen_string_literal: true

module Hyrax
  module Workflow
    class CommentNotification < GppNotification
      def workflow_recipients
        { to: library_reviewers }
      end

      def subject
        'Government Publications Portal: Submission Comments'
      end

      def message
        "#{user.display_name} (#{user.user_key}) has made a new comment on '#{title}'<br><br>" +
            "Comment: #{comment}<br><br>" +
            "To view all comments on this submission, please click here: #{link_to work_id, document_url}"
      end
    end
  end
end
