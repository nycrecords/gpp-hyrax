# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

user = User.find_by(email: ENV['LIBRARY_USER_EMAIL'])
count = 1
dspace_metadata = CSV.read(ENV['DSPACE_METADATA_CSV_PATH'], headers: true, encoding: 'ISO8859-1')
dspace_metadata.each do |row|
  puts count
  count+=1
  f = File.open('/Users/jyu/Desktop/Required Reports List.xls')
  uploaded_file = Hyrax::UploadedFile.create(user: user, file: f)
  f.close

  agency = row[2]
  additional_creators = row[3].split('||') unless row[3].nil?
  borough = row[4].split('||') unless row[4].nil?
  community_board_district = row[5].split('||') unless row[5].nil?
  associated_place = row[6].split('||') unless row[6].nil?
  school_district = row[7].split('||') unless row[7].nil?
  calendar_year = row[8] or row[9]
  calendar_year = calendar_year.split('||') unless calendar_year.nil?
  fiscal_year = row[10].split('||') unless row[10].nil?
  date_published = row[14] or row[15] or row[16]
  description = [row[17]]
  language = row[22].split('||') unless row[22].nil?
  subject = row[23].split('||') unless row[23].nil?
  sub_title = row[24] or row[25]
  sub_title = sub_title.split('||') unless sub_title.nil?
  title = [row[26]]
  report_type = row[28]

  work = NycGovernmentPublication.new
  actor = Hyrax::CurationConcern.actor
  attributes = { uploaded_files: [uploaded_file.id.to_s],
                 agency: agency,
                 additional_creators: additional_creators,
                 borough: borough,
                 community_board_district: community_board_district,
                 associated_place: associated_place,
                 school_district: school_district,
                 calendar_year: calendar_year,
                 fiscal_year: fiscal_year,
                 date_published: date_published,
                 description: description,
                 language: language,
                 subject: subject,
                 sub_title: sub_title,
                 title: title,
                 required_report_name: nil,
                 report_type: report_type,
                 member_of_collections_attributes: { '0' => {
                     id: Collection.where(title: 'Government Publication').first.id,
                     _destroy: 'false'
                 } } }
  actor_environment = Hyrax::Actors::Environment.new(work, user.ability, attributes)
  status = actor.create(actor_environment)

  if status
    approve_attributes = { name: 'approve', comment: '' }
    workflow_action_form = Hyrax::Forms::WorkflowActionForm.new(
        current_ability: user.ability,
        work: work,
        attributes: approve_attributes
    )
    workflow_action_form.save
  end
end