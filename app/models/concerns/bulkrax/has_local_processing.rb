# frozen_string_literal: true
# [gpp-override] Override to add required_report_name default
# [gpp-override] Override to add field validation

module Bulkrax::HasLocalProcessing
  extend ActiveSupport::Concern
  # This method is called during build_metadata
  # add any special processing here, for example to reset a metadata property
  # to add a custom property from outside of the import data
    def add_local
      add_default_values
      field_validation
    end

    def add_default_values
      self.parsed_metadata['required_report_name'] = "Not Required"
    end

    def field_validation
      required_fields = %w[title agency subject description date_published report_type language]
      csv_errors = validate_required_fields(required_fields)
      csv_errors << "fiscal_year or calendar_year" if associated_year_blank?

      raise StandardError, "Missing required elements, missing element(s) are: #{csv_errors.join(', ')}" unless csv_errors.empty?

      csv_errors.concat(validate_length_requirements)

      raise StandardError, csv_errors.join(" - ") unless csv_errors.empty?

      validate_years(:fiscal_year.to_s) if record[:fiscal_year.to_s].present?
      validate_years(:calendar_year.to_s) if record[:calendar_year.to_s].present?

      validate_date_published
    end

    def validate_required_fields(fields)
      missing_fields = fields.select { |field| record[field].to_s.strip.empty? }
      missing_fields.map(&:to_s)
    end

    def associated_year_blank?
      record[:fiscal_year.to_s].blank? && record[:calendar_year.to_s].blank?
    end

    def validate_length_requirements
      csv_errors = []
      csv_errors << "title must be between 10-150 characters." unless record[:title.to_s].length.between?(10, 150)
      csv_errors << "description must be between 100-300 characters." unless record[:description.to_s].length.between?(100, 300)
      csv_errors
    end

    def validate_years(field)
      years = record[field].to_s.split(';')
      invalid_years = years.reject { |year| valid_year?(year) }

      raise StandardError, "Invalid year entered for #{field}. Accepted format: YYYY. Year must be greater than 1600." unless invalid_years.empty?
    end

    def valid_year?(year)
      year.length == 4 && Date.strptime(year, '%Y') >= Date.new(1600)
    rescue ArgumentError, TypeError
      false
    end

    def validate_date_published
      error_msg = 'Invalid Date entered for date_published. Accepted format: YYYY-MM-DD'
      date_published = Date.strptime(record[:date_published.to_s], '%Y-%m-%d')

      raise StandardError, error_msg if date_published.year < 1000

      self.parsed_metadata['date_published'] = date_published.to_s
    rescue Date::Error
      raise StandardError, error_msg
    end
end
