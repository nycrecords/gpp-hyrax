# frozen_string_literal: true
module Gpp
  class MandatedReportEvent < ApplicationRecord
    belongs_to :required_report
    belongs_to :user

    enum event_type: {
      created: 'created',
      updated: 'updated',
      visibility_updated: 'visibility_updated'
    }

    validates :event_type, presence: true
  end
end
