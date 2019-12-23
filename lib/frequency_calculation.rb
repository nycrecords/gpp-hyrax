# frozen_string_literal: true

class FrequencyCalculation
  def initialize
    @calendar = Rails.configuration.calendar
  end

  def calculate(frequency, frequency_integer, start_date, end_date)
    dates = [@calendar.roll_forward(start_date)]

    return dates if frequency == 'Once'

    date = start_date
    end_date = calculate_end_date(start_date, end_date)
    frequency_symbol = get_frequency_symbol(frequency)

    while date < end_date
      date = date.advance(frequency_symbol => frequency_integer)
      dates << @calendar.roll_forward(date)
    end

    dates.uniq
  end

  def calculate_end_date(start_date, end_date)
    end_date_from_start_date = start_date + 3.years

    return end_date_from_start_date if end_date.nil?

    end_date < end_date_from_start_date ? end_date : end_date_from_start_date
  end

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