require 'csv'

desc 'Generate Late Reports and write to CSV'
task :report_request_to_csv, [:date] => :environment do |t, args|
  calendar = Rails.configuration.calendar
  date = Date.parse(args[:date])

  late_date = calendar.subtract_business_days(date, 11)
  late_reports = RequiredReportDueDate.includes(required_report: :agency)
                   .where(date_submitted: nil, delinquency_report_published_date: nil)
                   .where('grace_due_date < ?', late_date)


  csv_file = File.join(ENV['OPENDATA_CSV_PATH'],
                       'late_reports.csv')

  header = ["Title",
            "Agency",
            "Mandated Report Name",
            "Description",
            "Report Due Date",
            "Report Type",
            "Subject",
            "Date Published",
            "Associated Year - Calendar",
            "Language",
            "Filename"]

  CSV.open(csv_file, 'ab') do |writer|
    writer << header
  end

  late_reports.each do |report|
    required_report_due_date = report
    required_report = required_report_due_date.required_report
    agency = required_report.agency

    # Create PDF
    pdf = ApplicationController.new.render_to_string(template: 'report_request_mailer/notice.pdf.erb',
                                                     locals: { :@required_report_due_date => required_report_due_date,
                                                               :@required_report => required_report,
                                                               :@agency => agency },
                                                     layout: 'application.pdf')

    filename = "#{required_report_due_date.id.to_s}_report_request.pdf"
    File.write("#{ENV['LATE_REPORT_PDF_PATH']}/#{filename}", pdf)

    CSV.open(csv_file, 'ab') do |writer|
      writer << ["Late Notice - #{required_report.name}",
                 agency.name,
                 required_report.name,
                 required_report.description,
                 required_report_due_date.base_due_date,
                 "Delinquent Report Notice",
                 "Compliance",
                 date.to_s,
                 date.year.to_s,
                 "English",
                 filename]
    end
  end
end
