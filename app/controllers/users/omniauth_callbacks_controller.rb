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
    last_login_datetime = @user.last_sign_in_at

    # Display previous logon date and time to user if value is present
    if last_login_datetime.present?
      last_login_datetime_local = last_login_datetime.in_time_zone(Rails.configuration.local_timezone)
      last_login_string = last_login_datetime_local.strftime('%B %d, %Y %H:%M:%S')
      flash[:notice] = "Last login: #{last_login_string}"
    end

    sign_in_and_redirect @user
  end
end
