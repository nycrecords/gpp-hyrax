class ReportRequestMailer < ApplicationMailer
  def email(poc_emails)
    mail(from: 'munilib@records.nyc.gov', to: poc_emails, subject: 'Test Email', body: 'Test Email Body')
  end
end