class AuthorizeSubmitterMailer < ApplicationMailer
  def email(user)
    @user = user
    @timestamp = Time.now.strftime '%m/%d/%Y at %H:%M:%S'
    mail(from: ENV['LIBRARY_USER_EMAIL'],
         to: Role.find_by(name: 'library_reviewers').users.to_a,
         subject: 'GPP - Registration Notification')
  end
end