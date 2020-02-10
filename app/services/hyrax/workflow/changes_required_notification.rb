# frozen_string_literal: true

module Hyrax
  module Workflow
    class ChangesRequiredNotification < GppNotification
      def workflow_recipients
        { to: library_reviewers << depositor }
      end

      def subject
        'Government Publications Portal: Submission Changes Required'
      end

      def message
        "You submitted: #{title}<br><br>" +
            "Your submission has been rejected by the Municipal Library Staff with the following explanation:<br><br>" +
            "<strong>#{comment}</strong><br><br>" +
            "Your submission has not been deleted. You can access your submission #{link_to "here", document_url}, or in the 'Works' section of the Dashboard.<br><br>" +
            "To make changes, click 'Edit', make the required change, and click 'Save Changes'. Then click 'Review and Approval', choose 'Request Review' and click 'Submit'.<br><br>" +
            "Emails to this mailbox are not monitored. Please contact the Municipal Library at municipal-library-admins@records.nyc.gov.<br><br>" +
            "Thank you,<br>" +
            "Municipal Library"
      end
    end
  end
end
