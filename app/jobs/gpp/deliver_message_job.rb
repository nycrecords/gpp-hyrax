# frozen_string_literal: true

require 'net/smtp'

# [gpp-fix] Dispatches the email portion of a Mailboxer::Message asynchronously.
# The Mailboxer record itself are created synchronously by Hyrax::MessengerService.deliver,
# so the in-app notification is visible immediately even if SMTP fails or is delayed.
module Gpp
  class DeliverMessageJob < ApplicationJob
    queue_as :default

    # Catch SMTP failures and retry
    retry_on Net::ReadTimeout,             wait: :exponentially_longer, attempts: 5
    retry_on Net::OpenTimeout,             wait: :exponentially_longer, attempts: 5
    retry_on Errno::ECONNREFUSED,          wait: :exponentially_longer, attempts: 5
    retry_on Net::SMTPServerBusy,          wait: :exponentially_longer, attempts: 5

    # Don't retry errors that are unlikely to succeed later
    discard_on Net::SMTPSyntaxError
    discard_on Net::SMTPFatalError

    # Don't retry if the message was deleted
    discard_on ActiveRecord::RecordNotFound

    # @param message_id [Integer] id of an existing Mailboxer::Message record.
    #   The record is expected to already have its receipts persisted by
    #   Hyrax::MessengerService.deliver.
    def perform(message_id:)
      message = Mailboxer::Message.find(message_id)
      receiver_receipts = message.receipts.where(mailbox_type: 'inbox')
      Mailboxer::MailDispatcher.new(message, receiver_receipts).call
    rescue => e
      Rails.logger.error(
        "[DeliverMessageJob] failed: message_id=#{message_id} " \
          "error=#{e.class} - #{e.message}"
      )
      raise
    end
  end
end
