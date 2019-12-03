class ReportRequestMailer < ApplicationMailer
  def email(required_report)
    @agency = required_report.agency
    mail(from: 'munilib@records.nyc.gov', to: @agency.point_of_contact_emails, subject: 'Notice of Late Publication')
  end
end