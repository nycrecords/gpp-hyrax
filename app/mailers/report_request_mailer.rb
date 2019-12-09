class ReportRequestMailer < ApplicationMailer
  def email(agency, pdf)
    attachments['report_request.pdf'] = pdf

    mail(from: 'munilib@records.nyc.gov',
         to: agency.point_of_contact_emails,
         cc: Role.find_by(name: 'library_reviewers').users.to_a,
         subject: 'Notice of Late Publication')
  end
end