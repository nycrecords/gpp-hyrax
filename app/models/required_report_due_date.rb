# frozen_string_literal: true

class RequiredReportDueDate < ApplicationRecord
  belongs_to :required_report

  # Generates and returns attributes for parent class: an array of hashes with 'due_date' key.
  # Ex:
  #     [ { due_date: 2020-01-01 }, { due_date: 2020-02-01 }, ... ]
  def generate_due_date_attributes(frequency, frequency_integer, start_date, end_date)
    frequency_calculation = FrequencyCalculation.new
    due_dates = frequency_calculation.calculate(frequency, frequency_integer, start_date, end_date)
    due_dates.map { |d| { due_date: d } }
  end
end
