class SessionsController < Devise::SessionsController
  SAML_SETTINGS = Devise.omniauth_configs[:saml].strategy

  def destroy
    # Preserve the saml_uid in the session
    saml_uid = session["saml_uid"]
    super do
      session["saml_uid"] = saml_uid
    end
  end

  def after_sign_out_path_for(_)
    if session['saml_uid'] && SAML_SETTINGS.idp_slo_target_url
      user_saml_omniauth_authorize_path(:locale=>nil) + "/spslo"
    else
      super
    end
  end
end