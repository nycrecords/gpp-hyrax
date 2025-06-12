json.extract! required_report, :id, :agency, :name, :description, :local_law, :charter_and_code, :automated_date, :frequency, :frequency_integer, :other_frequency_description, :start_date, :end_date, :last_published_date, :required_distribution, :report_deadline, :additional_notes, :created_at, :updated_at
json.url mandated_report_url(required_report, format: :json)
