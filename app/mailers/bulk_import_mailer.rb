class BulkImportMailer < ApplicationMailer
  default from: ENV['DEFAULT_FROM']

  def email(importer, filename)
    @importer = importer
    @file_name = filename

    mail(to: [ENV['LIBRARY_USER_EMAIL'], @importer.user.to_s],
         cc: Role.find_by(name: 'library_reviewers').users.to_a,
         subject: 'Government Publications Portal: Bulk Import Completed')
  end
end
