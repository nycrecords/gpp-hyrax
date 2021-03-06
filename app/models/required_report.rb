# frozen_string_literal: true

class RequiredReport < ApplicationRecord
  has_many :required_report_due_dates
  belongs_to :agency, foreign_key: 'agency_name', primary_key: 'name'

  accepts_nested_attributes_for :required_report_due_dates

  # Convert empty name and agency fields to null
  nilify_blanks only: [:name, :agency]

  # Parse frequency and frequency integer into readable string
  def frequency_string
    return '' if frequency.nil?

    frequency_string = frequency

    if frequency_string != 'Once'
      if frequency_integer == 1
        frequency_string = frequency_string.delete_suffix('s')
      end
      frequency_string = frequency_string.sub('X', frequency_integer.to_s)
    end

    frequency_string
  end
end
