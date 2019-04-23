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
      super.first || ""
    end

    def description
      super.first || ""
    end

    self.terms = [:title, :sub_title, :agency, :additional_creators, :subject, :description,
                  :date_issued, :report_type, :language, :fiscal_year, :calendar_year, :borough, :school_district,
                  :community_board_district, :associated_place, :visibility]
    self.required_fields = [:title, :agency, :subject, :description, :date_issued, :report_type, :language]


    def primary_terms
      # REMOVED REQUIRED FIELDS TO MAKE THEM SHOW IN ORDER WE DEFINED.
      primary = (terms - [:visibility])

      (required_fields - primary).each do |missing|
        Rails.logger.warn("The form field #{missing} is configured as a " \
                            'required field, but not as a term. This can lead ' \
                            'to unexpected behavior. Did you forget to add it ' \
                            "to `#{self.class}#terms`?")
      end

      primary
    end
  end
end
