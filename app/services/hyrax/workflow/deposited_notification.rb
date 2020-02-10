# frozen_string_literal: true

module Hyrax
  module Workflow
    class DepositedNotification < GppNotification
      def workflow_recipients
        { to: library_reviewers << depositor }
      end

      def subject
        'Government Publications Portal: Submission Approval'
      end

      def message
        "You submitted: #{title}<br><br>" +
            "Your submission has been accepted and archived in the Government Publications Portal.<br><br>" +
            "Emails to this mailbox are not monitored. Please contact the Municipal Library at municipal-library-admins@records.nyc.gov.<br><br>" +
            "Thank you,<br>" +
            "Municipal Library"
      end
    end
  end
end
