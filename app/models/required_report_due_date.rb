# frozen_string_literal: true

class RequiredReportDueDate < ApplicationRecord
  belongs_to :required_report

  # Generates and returns attributes for parent class: an array of hashes with 'base_due_date' and grace_due_date keys.
  # Empty array is returned if frequency or start_date is blank or if automated_date is false.
  #
  # Ex:
  #     [ { base_due_date: 2020-01-01, grace_due_date: 2020-01-01 }, ... ]
  def generate_due_date_attributes(frequency, frequency_integer, start_date, end_date, automated_date)
    return [] if (frequency.blank? || start_date.blank? || automated_date == false)

    # Convert string parameters to proper types.
    frequency_integer = frequency_integer.to_i

    frequency_calculation = FrequencyCalculation.new
    base_dates, grace_dates = frequency_calculation.calculate(frequency,
                                                              frequency_integer,
                                                              start_date,
                                                              end_date)

    due_dates = []
    base_dates.zip(grace_dates).each do |base_date, grace_date|
      due_dates << { :base_due_date => base_date, :grace_due_date => grace_date }
    end

    due_dates.uniq { |h| h[:base_due_date] }
  end
end
