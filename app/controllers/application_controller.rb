class ApplicationController < ActionController::Base
  auto_session_timeout 30.minutes
  before_timedout_action

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

  # Redirect to location that triggered authentication or to homepage
  def after_sign_in_path_for(resource)
    gpp_collection = Collection.where(title: 'Government Publications').first
    path = gpp_collection.present? ? hyrax.collection_path(gpp_collection) : root_path
    stored_location_for(resource) || path
  end
end
