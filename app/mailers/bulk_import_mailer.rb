class BulkImportMailer < ApplicationMailer
  default from: ENV['DEFAULT_FROM']

  def email(importer)
    @importer = importer
    mail(to: ENV['LIBRARY_USER_EMAIL'],
         cc: Role.find_by(name: 'library_reviewers').users.to_a,
         subject: 'Government Publications Portal: Bulk Import Completed')
  end
end
