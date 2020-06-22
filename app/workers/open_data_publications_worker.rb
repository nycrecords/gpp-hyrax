require 'csv'

class OpenDataPublicationsWorker
  include Sidekiq::Worker

  def perform(*args)
    file = File.join(ENV['OPENDATA_CSV_PATH'],
                     "opendata_publications_#{Time.now.strftime('%Y-%m-%d_%H-%M-%S')}.csv")
    publications = NycGovernmentPublication.where('suppressed_bsi': 'false')
    header = ["Title",
              "Sub-Title",
              "Agency",
              "Required Report Name",
              "Additional Creators",
              "Subject",
              "Description",
              "Date Published",
              "Report Type",
              "Languages",
              "Associated Year - Fiscal",
              "Associated Year - Calendar",
              "Associated Borough",
              "Associate School District",
              "Associated Community Board District",
              "Associated Place",
              "Filename",
              "Last Modified"]
    CSV.open(file, 'w') do |writer|
      writer << header
      publications.each do |p|
        writer << [p.title[0],
                   format_multiple_values(p.sub_title),
                   p.agency,
                   p.required_report_name,
                   format_multiple_values(p.additional_creators),
                   format_multiple_values(p.subject),
                   p.description[0],
                   p.date_published,
                   p.report_type,
                   format_multiple_values(p.language),
                   format_multiple_values(p.fiscal_year),
                   format_multiple_values(p.calendar_year),
                   format_multiple_values(p.borough),
                   format_multiple_values(p.school_district),
                   format_multiple_values(p.community_board_district),
                   format_multiple_values(p.associated_place),
                   get_filenames(p.id),
                   p.date_modified.to_date.to_s]
      end
    end
  end

  def format_multiple_values(value)
    return if value.empty?
    delimited_value = value.join(',')
    return delimited_value unless value.length > 1
    "\"#{delimited_value}\""
  end

  def get_filenames(id)
    # Query solr for FileSet ids
    file_set_ids ||= begin
                       ActiveFedora::SolrService.query("proxy_in_ssi:#{id}",
                                                       rows: 10_000,
                                                       fl: "ordered_targets_ssim")
                         .flat_map { |x| x.fetch("ordered_targets_ssim", []) }
                     end
    # Query for FileSet and select title attribute
    filename_nested_array = FileSet.where(id: file_set_ids).pluck('title')
    # Convert multidimensional array to single array of strings
    filename_array = filename_nested_array.map { |strings| strings.join(', ') }
    # Format array for values
    format_multiple_values(filename_array)
  end
end