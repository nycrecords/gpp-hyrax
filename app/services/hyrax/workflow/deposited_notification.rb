module Hyrax
  module Workflow
    class DepositedNotification < AbstractNotification
      private

      def subject
        'Government Publications Portal: Approval'
      end

      def message
        "You submitted: #{title}<br><br>" +
        "Your submission has been accepted and archived in the Government Publications Portal.<br><br>" +
        "Emails to this mailbox are not monitored. Please contact the Municipal Library at municipal-library-admins@records.nyc.gov.<br><br>" +
        "Thank you,<br>" +
        "Municipal Library"
      end

      def users_to_notify
        user_key = ActiveFedora::Base.find(work_id).depositor
        super << ::User.find_by(email: user_key)
      end
    end
  end
end
