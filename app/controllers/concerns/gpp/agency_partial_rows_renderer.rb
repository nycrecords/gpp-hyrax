# frozen_string_literal: true
module Gpp
  module AgencyPartialRowsRenderer
    def render_rows(partial:, locals:, message: nil, options: {})
      @agency.reload
      render json: {
        html: render_to_string(partial: partial, locals: locals.merge(agency: @agency)),
        message: message
      }.merge(options)
    end
  end
end
