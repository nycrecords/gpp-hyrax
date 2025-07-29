# frozen_string_literal: true
module Gpp
  class UpdateLateNoticeSuppressionJob < ApplicationJob
    queue_as :default

    def perform(suppress_late_notice, late_notice_id)
      late_notice = NycGovernmentPublication.where(id: late_notice_id).first
      return unless late_notice

      late_notice['suppressed_late_notice'] = suppress_late_notice
      late_notice.save!
    end
  end
end
