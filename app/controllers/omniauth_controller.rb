class OmniauthController < Devise::SessionsController
  def new
    redirect_to user_saml_omniauth_authorize_path
  end
end