class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  include NYCID
  def saml
    @user = User.from_omniauth(request.env["omniauth.auth"])
    if @user.email_validated.nil? || @user.try(:email_validated) == false
      email_validation_status = NYCIDWebServices.check_email_validation_status(guid: @user.guid)
      if email_validation_status == false
        redirect_to validate_email(email_address: @user.email)
        return
      end
    end
    set_flash_message :notice, :success, kind: "SAML"
    sign_in_and_redirect @user
  end
end