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
      csv_errors = []
      self.record.each do |key, value| csv_errors.push(key) if value.to_s.blank? end
      raise StandardError, "Missing required elements, missing element(s) are: #{csv_errors.join(', ')}" unless csv_errors.blank?

      # Handle required fields validation
      raise StandardError, "Title is required and must be between 10-150 characters" if !record[:title.to_s].length.between?(10, 150)
      raise StandardError, "Description is required and must be between 100-300 characters." if !record[:description.to_s].length.between?(100, 300)

      # Handle date_published validation and conversion
      begin
        date_published_conversion = Date.strptime(record[:date_published.to_s], '%m/%d/%Y').to_s
        self.parsed_metadata[:date_published] = date_published_conversion
      rescue
        raise Date::Error, 'Invalid Date entered for Date Published. Accepted format: MM/DD/YYYY"'
      end
    end
end
