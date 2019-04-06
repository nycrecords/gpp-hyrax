class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def saml
    @user = User.from_omniauth(request.env["omniauth.auth"])
    set_flash_message :notice, :success, kind: "SAML"
    sign_in_and_redirect @user
  end
end