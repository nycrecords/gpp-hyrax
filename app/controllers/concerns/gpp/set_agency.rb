# frozen_string_literal: true
module Gpp
  module SetAgency
    extend ActiveSupport::Concern

    included do
      before_action :set_agency, only: [:edit, :create, :destroy]
    end

    private

    def set_agency
      @agency = Agency.find(params[:id])
    end
  end
end
