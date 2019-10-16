# frozen_string_literal: true

module Hyrax
  module Workflow
    class ChangesRequiredNotification < GppNotification
      def workflow_recipients
        { to: library_reviewers << depositor }
      end

      def subject
        'Your deposit requires changes'
      end

      def message
        "#{title} (#{link_to work_id, document_url}) requires additional changes before approval.\n\n '#{comment}'"
      end
    end
  end
end
