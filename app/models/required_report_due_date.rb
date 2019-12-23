# frozen_string_literal: true

class RequiredReportDueDate < ApplicationRecord
  belongs_to :required_report

  def generate_due_date_attributes(frequency, frequency_integer, start_date, end_date)
    frequency_calculation = FrequencyCalculation.new
    due_dates = frequency_calculation.calculate(frequency, frequency_integer, start_date, end_date)
    due_dates.map { |d| { due_date: d } }
  end
end
