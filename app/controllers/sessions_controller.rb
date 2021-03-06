class SessionsController < Devise::SessionsController
  skip_before_action :check_concurrent_session

  auto_session_timeout_actions
  SAML_SETTINGS = Devise.omniauth_configs[:saml].strategy

  def destroy
    # Preserve the saml_uid in the session
    saml_uid = session['saml_uid']
    duplicate = session[:duplicate]
    user = current_user
    super do
      user.update_attributes(unique_session_id: nil) unless duplicate
      session['saml_uid'] = saml_uid
      response.headers['Clear-Site-Data'] = '"*"'
    end
  end

  # Redirect to '/spslo' is required for SP initiated Single Logout
  def after_sign_out_path_for(_)
    if session['saml_uid'] && SAML_SETTINGS.idp_slo_target_url
      user_saml_omniauth_authorize_path(locale: nil) + '/spslo'
    else
      super
    end
  end

  def timeout
    redirect_to user_saml_omniauth_authorize_path(locale: nil) + '/spslo'
  end
end
