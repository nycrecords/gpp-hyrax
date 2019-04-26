module AdvancedSearchFields
  extend ActiveSupport::Concern

  included do
    configure_blacklight do |config|
      # Attributes to include in the advanced search form
      adv_search_attrs = [:title, :sub_title, :agency, :additional_creators, :subject, :description,
                          :date_issued, :report_type, :language, :fiscal_year, :calendar_year, :borough, :school_district,
                          :community_board_district, :associated_place]
      already_included_attrs = [:contributor, :date_created, :title, :creator, :subject, :batch,
                                :description, :displays_in, :geographic_name, :held_by, :identifier,
                                :language, :publisher, :resource_type]
      adv_search_attrs -= already_included_attrs

      adv_search_attrs.each do |attr|
        field_name = attr.to_s.underscore
        config.add_search_field(field_name) do |field|
          field.include_in_simple_select = false
          field.solr_local_parameters = { qf: field_name + '_tesim' }
          # using :format_attr for :format because :format refers to the response
          # format in rails controllers
          if attr == :format
            field.field = "format_attr"
            field.label = "Format test"
          end
        end
      end
    end
  end # included
end