module Hyrax
  class CollectionForm < Hyrax::Forms::CollectionForm
    #####
    # Defaults fields to be KEPT in the Collection
    #   creator
    #   title (assigned to vdc_title by the collection actor)

    #####
    # New fields to be ADDED to the Collection
    #
    # self.required_fields += [:vdc_creator]
    # self.terms += [:vdc_creator]
    # self.required_fields += [:vdc_title]
    # self.terms += [:vdc_title]
    # self.required_fields += [:collection_size]
    # self.terms += [:collection_size]

    # OPTIONAL/REQUIRED (depending on visibility)
    # We want these to come first so that when they change position
    # from required
    # self.terms += [:abstract]

    # OPTIONAL
    # self.terms += [:funder]
    # self.terms += [:note]

    #####
    # Default fields to be REMOVED from the Collection
    # self.required_fields -= [:keyword]
    # self.required_fields -= [:rights]
    # self.required_fields -= [:creator]
    # self.terms -= [:keyword]
    # self.terms -= [:creator]
    # self.terms -= [:contributor]
    # self.terms -= [:publisher]
    # self.terms -= [:subject]
    # self.terms -= [:language]
    # self.terms -= [:identifier]
    # self.terms -= [:based_near]
    # self.terms -= [:related_url]
    # self.terms -= [:source]
    # self.terms -= [:description] # Removed in favor of :abstract
    # self.terms -= [:date_created] # Removed in favor of :creation_date

    def primary_terms
      [:title]
    end

    def secondary_terms
      []
    end

    # Make title non-repeatable (single-value)
    # TODO: I'm not sure why both the self.multiple? and multiple?
    #       I need to investigate to see if this is a Hyrax bug.
    def self.multiple?(field)
      if [:title].include? field.to_sym
        false
      else
        super
      end
    end
    def multiple?(field)
      if [:title].include? field.to_sym
        false
      else
        super
      end
    end

    # Cast back to multi-value when saving
    def self.model_attributes(_)
      attrs = super
      attrs[:title] = Array(attrs[:title]) if attrs[:title]
      attrs
    end

    def title
      TitleWrapper.new(super)
    end

    class TitleWrapper < SimpleDelegator
      def first
        super || ''
      end

      def to_s
        first.to_s
      end

      def to_str
        first.to_str
      end
    end
  end
end