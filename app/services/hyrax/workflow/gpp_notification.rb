# frozen_string_literal: true

module Hyrax
  module Workflow
    # GppNotification is a subclass of AbstractNotification and uses workflow_recipients to override recipients from
    # NotificationService.
    class GppNotification < AbstractNotification
      def initialize(entity, comment, user, recipients = {})
        recipients ||= {}
        super
        @recipients = workflow_recipients.with_indifferent_access
      end

      def self.send_notification(entity:, comment:, user:, recipients: {})
        super
      end

      def workflow_recipients
        raise NotImplementedError, 'Implement workflow_recipients in a child class'
      end

      # Users in the role library_reviewers
      def library_reviewers
        Role.find_by(name: 'library_reviewers').users.to_a
      end

      # User who deposited the work
      def depositor
        ::User.where(email: document.depositor).first
      end
    end
  end
end
