# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'csv'
require 'json'

# Populate agencies table
agencies = File.read(ENV['AGENCIES_JSON_PATH'])
JSON.parse(agencies).each do |agency|
  Agency.create(name: agency['name'], point_of_contact_emails: agency['point_of_contact_emails'])
end

# Populate required_reports and required_report_due_dates tables
required_reports = CSV.read(ENV['REQUIRED_REPORTS_CSV_PATH'], headers: true, encoding: 'ISO8859-1')
required_reports.each do |row|
  # Data formatting
  frequency = row[4].titleize.strip unless row[4].blank?
  start_date = Date.parse(row[11]) unless row[11].blank?
  end_date = Date.parse(row[12]) unless row[12].blank?

  # Calculate due dates for each required report
  due_date_attributes = RequiredReportDueDate.new.generate_due_date_attributes(frequency,
                                                                               row[5],
                                                                               row[11],
                                                                               row[12])

  RequiredReport.create({agency_name: row[1],
                         name: row[2],
                         description: row[3],
                         frequency: frequency,
                         frequency_integer: row[5].to_i,
                         other_frequency_description: row[6],
                         charter_and_code: row[9],
                         local_law: row[10],
                         start_date: start_date,
                         end_date: end_date
                        }.merge(required_report_due_dates_attributes: due_date_attributes))
end