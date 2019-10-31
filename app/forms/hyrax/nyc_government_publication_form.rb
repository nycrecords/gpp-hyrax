# Generated via
#  `rails generate hyrax:work NycGovernmentPublication`
module Hyrax
  # Generated form for NycGovernmentPublication
  class NycGovernmentPublicationForm < Hyrax::Forms::WorkForm
    self.model_class = ::NycGovernmentPublication

    def self.multiple?(field)
      if [:title, :description].include? field.to_sym
        false
      else
        super
      end
    end

    def self.model_attributes(_)
      attrs = super
      attrs[:title] = Array(attrs[:title]) if attrs[:title]
      attrs[:description] = Array(attrs[:description]) if attrs[:description]
      attrs
    end

    def title
      super.first || ''
    end

    def description
      super.first || ''
    end

    self.terms = [:title, :sub_title, :agency, :required_report_type, :additional_creators, :subject, :description,
                  :date_published, :report_type, :language, :fiscal_year, :calendar_year, :borough, :school_district,
                  :community_board_district, :associated_place]
    self.required_fields = [:title, :agency, :required_report_type, :subject, :description, :date_published,
                            :report_type, :language]

  end
end
