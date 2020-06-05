class NewSubmitterMailer < ApplicationMailer
  def email(user)
    mail(from: ENV['LIBRARY_USER_EMAIL'],
         to: user.email,
         subject: 'GPP - Account Submitted for Approval')
  end
end