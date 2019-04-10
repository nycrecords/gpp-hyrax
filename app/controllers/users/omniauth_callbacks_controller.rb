class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  include NYCID::NYCID
  def saml
    @user = User.from_omniauth(request.env["omniauth.auth"])
    if @user.email_validated.nil? || @user.try(:email_validated) == false
      email_validation_status = check_email_validation_status(guid: @user.guid)
    end
    set_flash_message :notice, :success, kind: "SAML"
    sign_in_and_redirect @user
  end
end