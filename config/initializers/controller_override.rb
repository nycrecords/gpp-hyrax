# frozen_string_literal: true

# OVERRIDE: This overrides deny_access_for_anonymous_user on Controller and renders unauthorized.
#
# Base file: https://github.com/samvera/hyrax/blob/2.5.1/app/controllers/concerns/hyrax/controller.rb
Hyrax::Controller.class_eval do
  def deny_access_for_anonymous_user(exception, json_message)
    session['user_return_to'.freeze] = request.url
    respond_to do |wants|
      wants.html { render 'hyrax/base/unauthorized', status: :unauthorized }
      wants.json { render_json_response(response_type: :unauthorized, message: json_message) }
    end
  end
end