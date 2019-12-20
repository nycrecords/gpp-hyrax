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

# Populate required_reports table
required_reports = CSV.read(ENV['REQUIRED_REPORTS_CSV_PATH'], headers: true, encoding: 'ISO8859-1')
required_reports.each do |row|
  RequiredReport.create(id: row[0],
                        agency_name: row[1].to_s,
                        name: row[2].to_s,
                        description: row[3].to_s,
                        frequency: row[4].to_s,
                        frequency_integer: row[5].to_i,
                        other_frequency_description: row[6].to_s,
                        charter_and_code: row[9].to_s,
                        local_law: row[10].to_s,
                        start_date: row[11].to_s,
                        end_date: row[12].to_s
  )
end