json.extract! required_report, :id, :agency, :name, :description, :local_law, :charter_and_code, :automated_date, :frequency, :frequency_integer, :other_frequency_description, :start_date, :end_date, :last_published_date, :created_at, :updated_at
json.url required_report_url(required_report, format: :json)
