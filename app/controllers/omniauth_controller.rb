class OmniauthController < Devise::SessionsController
  def new
    redirect_to user_saml_omniauth_authorize_path
  end

  def profile
    redirect_to ENV['NYC_ID_WEB_SERVICES_URL']
  end
end