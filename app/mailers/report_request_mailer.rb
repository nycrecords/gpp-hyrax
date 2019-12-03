class ReportRequestMailer < ApplicationMailer
  def email(report)
    @required_report_due_date = report
    @required_report = @required_report_due_date.required_report
    @agency = @required_report.agency

    mail(from: 'munilib@records.nyc.gov',
         to: @agency.point_of_contact_emails,
         cc: Role.find_by(name: 'library_reviewers').users.to_a,
         subject: 'Notice of Late Publication')
  end
end