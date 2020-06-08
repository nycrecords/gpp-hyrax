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
    :trackable,
    :omniauthable,
    omniauth_providers: [:saml],
    authentication_keys: [:email]
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
  # @param [Hash] user_json
  def self.from_omniauth(user_json)
    user = where(guid: user_json['id']).first
    if user.nil?
      user = where(email: user_json['email']).first_or_create
      send_new_user_emails = true
    else
      send_new_user_emails = false
    end

    user.guid = user_json['id']
    user.first_name = user_json['firstName']
    user.middle_initial = user_json['middleInitial']
    user.last_name = user_json['lastName']
    user.email = user_json['email']
    user.email_validated = user_json['validated']
    user.active = user_json['active']
    user.nyc_employee = user_json['nycEmployee']
    user.has_nyc_account = user_json['hasNYCAccount']
    user.display_name = "#{user.first_name} #{user.last_name}"
    user.save

    if send_new_user_emails
      AuthorizeSubmitterMailer.email(user).deliver
      NewSubmitterMailer.email(user).deliver
    end
    user
  end

  # Mailboxer (the notification system) needs the User object to respond to this method
  # in order to send emails
  def mailboxer_email(_object)
    email
  end
end
