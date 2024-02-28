# Controller which implements Omniauth callbacks.
class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  skip_before_action :verify_authenticity_token, :check_concurrent_session

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

    # Get the User Attributes from NYC.ID
    user_json = nycidwebservices.search_user(saml_attrs[:GUID])
    
    # Get the domain for the Users' email address
    email_domain = user_json['email'].split('@').last

    # Users whose email domain is in the approved list (but are not NYC Employees) should be treated as NYC Employees
    if APPROVED_NYCID_DOMAINS.include?(email_domain)
      user_json['nycEmployee'] = true
    end

    # Users who are not NYC Employees (or treated as NYC Employees) cannot login
    if user_json['nycEmployee'] == false
      flash[:notice] = "Looks like you logged in with a public user account. That isn't needed to search reports so we've logged you out."
      gpp_collection = Collection.where(title: 'Government Publications').first
      path = gpp_collection.present? ? hyrax.collection_path(gpp_collection) : root_path
      redirect_to path and return
    end

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

  def after_omniauth_failure_path_for(scope)
    ENV['RAILS_HOST']
  end
end
