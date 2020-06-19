require 'csv'
require 'open-uri'

class OpenDataRequiredReportsWorker
  include Sidekiq::Worker

  def perform(*args)
    file = File.join(ENV['OPENDATA_CSV_PATH'],
                     "opendata_required_reports_#{Time.now.strftime('%Y-%m-%d_%H-%M-%S')}.csv")
    required_reports = RequiredReport.all.order(agency_name: :asc, name: :asc)
    header = ['Agency',
              'Name',
              'Description',
              'Frequency',
              'Local Law',
              'Charter Code',
              'Last Published Date',
              'See All Reports']
    CSV.open(file, 'w') do |writer|
      writer << header
      required_reports.each do |r|
        writer << [r.agency_name,
                   r.name,
                   r.description,
                   r.frequency_string,
                   r.local_law,
                   r.charter_and_code,
                   r.last_published_date,
                   create_link_to_reports(r.agency_name, r.name)]
      end
    end
  end

  def create_link_to_reports(agency, report_name)
    ENV['RAILS_HOST'] + "/catalog?utf8=%E2%9C%93&locale=en&agency=#{URI::encode(agency)}" +
      "&required_report_name=#{URI::encode(report_name)}" +
      '&sort=date_published_ssi+desc&search_field=advanced'
  end
end