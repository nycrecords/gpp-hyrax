class ApplicationController < ActionController::Base
  before_action :set_cache_headers, :check_concurrent_session
  auto_session_timeout 30.minutes

  helper Openseadragon::OpenseadragonHelper
  # Adds a few additional behaviors into the application controller
  include Blacklight::Controller
  skip_after_action :discard_flash_if_xhr
  include Hydra::Controller::ControllerBehavior

  # Adds Hyrax behaviors into the application controller
  include Hyrax::Controller
  include Hyrax::ThemedLayoutController
  with_themed_layout '1_column'

  protect_from_forgery with: :exception, except: [:saml]

  def render_400
    render 'errors/not_found', status: 400, formats: :html
  end

  def render_404
    render 'errors/not_found', status: 404, formats: :html, layout: 'layouts/hyrax/1_column'
  end

  # Redirect user to sign_out if user is has another session
  def check_concurrent_session
    return unless is_already_logged_in?
    session[:duplicate] = true
    redirect_to main_app.destroy_user_session_path
  end

  # Return boolean value of whether user is logged in
  def is_already_logged_in?
    current_user && (session.id.to_s != current_user.unique_session_id)
  end

  # Redirect to location that triggered authentication or to homepage
  def after_sign_in_path_for(resource)
    # Generate new session id and update in user.unique_session_id
    session.options[:id] = session.instance_variable_get(:@by).generate_sid
    session.options[:renew] = false
    resource.update_attributes(unique_session_id: session.id)

    # Get path to Government Publications collection or homepage if collection not found
    gpp_collection = Collection.where(title: 'Government Publications').first
    path = gpp_collection.present? ? hyrax.collection_path(gpp_collection) : root_path

    stored_location_for(resource) || path
  end

  def active_url
    # Used by session timeout to retain session for importers route
    return main_app.active_path
  end

  # Error caught in catalogController
  def render_rsolr_exceptions(exception)
    exception_text = exception.to_s

    if exception_text.include?('java.lang.NumberFormatException') ||
      exception_text.include?("Can't determine a Sort Order")
      render_400
    else
      render_404
    end
  end

  private

  def set_cache_headers
    response.headers['Cache-Control'] = 'max-age=0, no-cache, no-store, must-revalidate'
    response.headers['Pragma'] = 'no-cache'
    response.headers['Expires'] = '-1'
  end
end
