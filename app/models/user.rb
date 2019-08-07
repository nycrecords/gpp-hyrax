class User < ApplicationRecord
  # Connects this user object to Hydra behaviors.
  include Hydra::User
  # Connects this user object to Role-management behaviors.
  include Hydra::RoleManagement::UserRoles


  # Connects this user object to Hyrax behaviors.
  include Hyrax::User
  include Hyrax::UserUsageStats

  if Blacklight::Utils.needs_attr_accessible?
    attr_accessible :email, :password, :password_confirmation
  end
  # Connects this user object to Blacklights Bookmarks.
  include Blacklight::User
  # Include devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  # remove :database_authenticatable, remove :validatable to integrate with SAML
  devise_modules = [
      :registerable,
      :recoverable,
      :rememberable,
      :omniauthable,
      omniauth_providers: [:saml],
      authentication_keys: [:guid]
  ]

  devise(*devise_modules)
  # Method added by Blacklight; Blacklight uses #to_s on your
  # user class to get a user-displayable login/identifier for
  # the account.
  def to_s
    email
  end


  # When a user authenticates via SAML, find their User object or make
  # a new one. Populate it with data we get from SAML.
  # @param [OmniAuth::AuthHash] auth
  def self.from_omniauth(auth)
    Rails.logger.debug "auth = #{auth.inspect}"
    saml_attrs = auth.extra.response_object.attributes
    # Uncomment the debugger above to capture what a SAML auth object looks like for testing
    user = where(guid: saml_attrs[:GUID]).first_or_create
    user.guid = saml_attrs[:GUID]
    user.first_name = saml_attrs[:givenName]
    user.middle_initial = saml_attrs[:middleName]
    user.last_name = saml_attrs[:sn]
    user.email_validated = saml_attrs[:nycExtEmailValidationFlag].to_s == "True" ? true : false
    user.email = auth.info.email
    user.display_name = "#{user.first_name} #{user.middle_initial or ''} #{user.last_name}"
    user.save
    user
  end

  # Mailboxer (the notification system) needs the User object to respond to this method
  # in order to send emails
  def mailboxer_email(_object)
    email
  end
end
