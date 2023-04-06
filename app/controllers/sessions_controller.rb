class SessionsController < Devise::SessionsController
  skip_before_action :check_concurrent_session
  auto_session_timeout_actions
  SAML_SETTINGS = Devise.omniauth_configs[:saml].strategy

  def destroy
    # Preserve the saml_uid in the session
    saml_uid = session['saml_uid']
    saml_session_index = session['saml_session_index']
    duplicate = session[:duplicate]
    user = current_user
    super do
      user.update_attributes(unique_session_id: nil) unless duplicate
      session['saml_uid'] = saml_uid
      session['saml_session_index'] = saml_session_index
      response.headers['Clear-Site-Data'] = '"*"'
    end
  end

  # Redirect to '/spslo' is required for SP initiated Single Logout
  def after_sign_out_path_for(_)
    if session['saml_uid'] && session['saml_session_index'] && SAML_SETTINGS.idp_slo_service_url
      user_saml_omniauth_authorize_path(locale: nil) + '/spslo'
    else
      super
    end
  end

  def timeout
    path = ActiveModel::Type::Boolean.new.cast(ENV['LOCAL_LOGIN']) ? destroy_user_session_path : user_saml_omniauth_authorize_path(locale: nil) + '/spslo'
    redirect_to path
  end
end
