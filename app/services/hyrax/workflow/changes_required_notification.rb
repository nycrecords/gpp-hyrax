module Hyrax
  module Workflow
    class ChangesRequiredNotification < AbstractNotification
      private

      def subject
        'Government Publications Portal: Rejection'
      end

      def message
        "You submitted: #{title}<br><br>" +
        "Your submission has been rejected by the Municipal Library Staff with the following explanation:<br><br>" +
        "#{comment}<br><br>" +
        "Your submission has not been deleted. You can access your submission at #{link_to work_id, document_path}, or in the 'My Works' page.<br><br>" +
        "Emails to this mailbox are not monitored. Please contact the Municipal Library at municipal-library-admins@records.nyc.gov.<br><br>" +
        "Thank you,<br>" +
        "Municipal Library"
      end

      def users_to_notify
        user_key = document.depositor
        super << ::User.find_by(email: user_key)
      end
    end
  end
end
