class ApplicationController < ActionController::Base
  before_action :set_cache_headers, :check_concurrent_session

  # auto_session_timeout 30.minutes
  # before_timedout_action

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

  # Redirect user to sign_out if user is has another session
  def check_concurrent_session
    return unless is_already_logged_in?
    session[:duplicate] = true
    redirect_to main_app.destroy_user_session_path
  end

  # Return boolean value of whether user is logged in
  def is_already_logged_in?
    current_user && (session.id != current_user.unique_session_id)
  end

  # adding this for time issue
   def authenticate
      redirect_to some_path if session[:session_key].nil?
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

  private

  def set_cache_headers
    response.headers['Cache-Control'] = 'max-age=0, no-cache, no-store, must-revalidate'
    response.headers['Pragma'] = 'no-cache'
    response.headers['Expires'] = '-1'
  end
end
