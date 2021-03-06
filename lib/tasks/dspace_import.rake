desc 'Import DSpace publications into Hyrax'
task :dspace_import => :environment do
  def split_elements(elements)
    values = []
    elements.each do |element|
      values << element.text
    end
    values
  end

  def get_required_report_name(id, name)
    if id.present?
      RequiredReport.where(id: id).first.name
    elsif name == 'Not Required'
      'Not Required'
    else
      nil
    end
  end

  user = User.find_by(email: ENV['LIBRARY_USER_EMAIL'])

  # Paths is an alphanumerically sorted array containing the paths to all directories found in DSPACE_EXPORT_PATH using the Dir.glob() function.
  paths = Dir.glob(format('%s/*', ENV['DSPACE_EXPORT_PATH'])).sort_by { |s| s.scan(/\d+/).map { |s| s.to_i } }
  paths[ENV['DSPACE_IMPORT_STARTING_INDEX'].to_i..-1].each do |path|
    # Handle metadata
    metadata = Nokogiri::XML(File.open(format('%s/dublin_core.xml', path)))
    agency = metadata.xpath('//dcvalue[@element="contributor"][@qualifier="author"]').text
    additional_creators = split_elements(metadata.xpath('//dcvalue[@element="contributor"][@qualifier="other"]'))
    borough = split_elements(metadata.xpath('//dcvalue[@element="coverage"][@qualifier="spatial-borough"]'))
    community_board_district = split_elements(metadata.xpath('//dcvalue[@element="coverage"][@qualifier="spatial-community-board-district"]'))
    associated_place = split_elements(metadata.xpath('//dcvalue[@element="coverage"][@qualifier="spatial-place"]'))
    school_district = split_elements(metadata.xpath('//dcvalue[@element="coverage"][@qualifier="spatial-school-district"]'))
    calendar_year = split_elements(metadata.xpath('//dcvalue[@element="coverage"][@qualifier="temporal-calendar"]'))
    fiscal_year = split_elements(metadata.xpath('//dcvalue[@element="coverage"][@qualifier="temporal-fiscal"]'))
    date_published = metadata.xpath('//dcvalue[@element="date"][@qualifier="issued"]').text
    description = [metadata.xpath('//dcvalue[@element="description"][@qualifier="abstract"]').text]
    language = split_elements(metadata.xpath('//dcvalue[@element="language"][@qualifier="iso"]'))
    subject = split_elements(metadata.xpath('//dcvalue[@element="subject"]'))
    sub_title = split_elements(metadata.xpath('//dcvalue[@element="title"][@qualifier="alternative"]'))
    title = [metadata.xpath('//dcvalue[@element="title"][@qualifier="none"]').text]
    report_type = metadata.xpath('//dcvalue[@element="type"][@qualifier="none"]').text
    required_report_name = get_required_report_name(metadata.xpath('//dcvalue[@element="identifier"][@qualifier="required-report-id"]').text,
                                                    metadata.xpath('//dcvalue[@element="type"][@qualifier="required-report-name"]').text)

    # Handle work
    work = NycGovernmentPublication.new
    actor = Hyrax::CurationConcern.actor
    attributes = { agency: agency,
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
                   required_report_name: required_report_name,
                   report_type: report_type,
                   member_of_collections_attributes: { '0' => {
                       id: Collection.where(title: 'Government Publication').first.id,
                       _destroy: 'false'
                   } } }
    actor_environment = Hyrax::Actors::Environment.new(work, user.ability, attributes)
    status = actor.create(actor_environment)

    if status
      # Handle files
      uploaded_files = []
      file_paths = Dir.glob(format('%s/*.pdf', path), File::FNM_CASEFOLD)
      file_paths.each do |file_path|
        file = File.open(file_path)
        uploaded_file = Hyrax::UploadedFile.create(user: user, file: file)
        uploaded_files << uploaded_file
        file.close
      end

      AttachFilesToWorkJob.perform_now(work, uploaded_files)

      approve_attributes = { name: 'approve', comment: '' }
      workflow_action_form = Hyrax::Forms::WorkflowActionForm.new(
          current_ability: user.ability,
          work: work,
          attributes: approve_attributes
      )
      workflow_action_form.save
      puts format('Finished processing submission at: %s', path)
    end
  end
end