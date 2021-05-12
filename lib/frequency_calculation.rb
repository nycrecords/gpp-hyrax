# frozen_string_literal: true

# Class for calculating due dates of required reports.
class FrequencyCalculation
  def initialize
    @calendar = Rails.configuration.calendar
  end

  # Returns an array of unique due dates.
  def calculate(frequency, frequency_integer, start_date, end_date)
    first_due_date = @calendar.roll_forward(start_date)
    base_dates = [first_due_date]
    grace_dates = [first_due_date]

    return [base_dates, grace_dates] if frequency == 'Once'

    base_date = start_date
    end_date = calculate_end_date(start_date, end_date)
    frequency_symbol = get_frequency_symbol(frequency)

    while base_date < end_date
      grace_date = base_date.advance(frequency_symbol => frequency_integer*2)
      base_date = base_date.advance(frequency_symbol => frequency_integer)
      base_dates << @calendar.roll_forward(base_date)
      grace_dates << @calendar.roll_forward(grace_date)
    end

    [base_dates, grace_dates]
  end

  # Returns an end_date, the date to stop calculating until.
  def calculate_end_date(start_date, end_date)
    end_date_from_start_date = start_date + 3.years

    return end_date_from_start_date if end_date.nil?

    end_date < end_date_from_start_date ? end_date : end_date_from_start_date
  end

  # Returns a symbol given a value from FrequenciesService.
  # Symbol is to be used as a parameter in Date.advance method.
  def get_frequency_symbol(frequency)
    string_to_symbol = {
      'Every X Years' => 'years',
      'Every X Months' => 'months',
      'Every X Weeks' => 'weeks',
      'Every X Days' => 'days'
    }

    string_to_symbol[frequency].to_sym
  end
end