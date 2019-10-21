json.extract! required_report, :id, :title, :agency, :frequency, :due_date, :citation, :created_at, :updated_at
json.url required_report_url(required_report, format: :json)
