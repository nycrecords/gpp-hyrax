# frozen_string_literal: true

# [gpp-override] Persist the in-app notification so users see it immediately,
# then send the email via Sidekiq so SMTP failures don't break workflow transitions.
module Hyrax
  class MessengerService
    def self.deliver(sender, recipients, body, subject, *_args)
      recipient_list = Array.wrap(recipients)
      message = build_and_save_message(sender, recipient_list, body, subject)
      Gpp::DeliverMessageJob.perform_later(message_id: message.id)
      StreamNotificationsJob.perform_later(recipients)
    end

    def self.build_and_save_message(sender, recipients, body, subject)
      now = Time.current

      conversation = Mailboxer::ConversationBuilder.new(
        subject: subject,
        created_at: now,
        updated_at: now
      ).build

      message = Mailboxer::MessageBuilder.new(
        sender: sender,
        conversation: conversation,
        recipients: recipients,
        body: body,
        subject: subject,
        created_at: now,
        updated_at: now
      ).build

      recipients.each do |r|
        message.receipts.build(receiver: r, mailbox_type: 'inbox', is_read: false)
      end
      message.receipts.build(receiver: sender, mailbox_type: 'sentbox', is_read: true)

      message.clean
      message.save!
      message
    end
  end
end
