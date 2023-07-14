class BulkImportMailer < ApplicationMailer
  default from: ENV['DEFAULT_FROM']

  def email(importer)
    @importer = importer
    @submitter = User.find_by(id: importer.user_id)
    mail(to: [ENV['LIBRARY_USER_EMAIL'], @submitter],
         cc: Role.find_by(name: 'library_reviewers').users.to_a,
         subject: 'Government Publications Portal: Bulk Import Completed')
  end
end
