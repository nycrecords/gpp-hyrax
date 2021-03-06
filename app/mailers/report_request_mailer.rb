class ReportRequestMailer < ApplicationMailer
  def email(agency, pdf)
    attachments['report_request.pdf'] = pdf

    mail(from: ENV['LIBRARY_USER_EMAIL'],
         to: agency.point_of_contact_emails,
         cc: Role.find_by(name: 'library_reviewers').users.to_a,
         subject: 'Notice of Late Publication')
  end

  def failure_email(failed_reports)
    @failed_reports = failed_reports

    mail(to: ENV['SUPPORT_DESK_EMAIL'],
         cc: ENV['LIBRARY_USER_EMAIL'],
         subject: 'report_request_worker Failure')
  end
end