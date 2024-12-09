# frozen_string_literal: true
# [gpp-override] Override to allow bulkrax jobs to be available in sidekiq status ui
module Bulkrax
  class ApplicationJob < ActiveJob::Base
    include Sidekiq::Status::Worker
  end
end