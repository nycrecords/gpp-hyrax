# Controller which implements Omniauth callbacks.
class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  include NYCID
  def saml
    saml_attrs = request.env['omniauth.auth'].extra.response_object.attributes
    nycidwebservices = NYCIDWebServices.new

    if saml_attrs[:nycExtEmailValidationFlag] == 'False'
      email_validation_status = nycidwebservices.check_email_validation_status(saml_attrs[:GUID])
      if email_validation_status == false
        redirect_to nycidwebservices.validate_email(saml_attrs[:mail])
        return
      end
    end

    user_json = nycidwebservices.search_user(saml_attrs[:GUID])
    @user = User.from_omniauth(user_json)

    set_flash_message :notice, :success, kind: 'SAML'
    sign_in_and_redirect @user
  end
end
