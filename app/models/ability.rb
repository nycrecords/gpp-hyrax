class Ability
  include Hydra::Ability
  
  include Hyrax::Ability
  self.ability_logic += [:everyone_can_create_curation_concerns]

  # Define any customized permissions here.
  def custom_permissions
    # Limits deleting objects to a the admin user
    #
    if current_user.admin?
      can [:create, :show, :add_user, :remove_user, :index, :edit, :update, :destroy], Role
      can [:index, :show, :new, :edit, :create, :update, :destroy, :agency_required_reports, :toggle_visibility], RequiredReport
    end

    if current_user.library_reviewers?
      can [:index, :show, :new, :edit, :create, :update, :destroy, :agency_required_reports, :toggle_visibility], RequiredReport
    end

    if current_user.agency_submitters?
      can [:agency_required_reports], RequiredReport
    end

    if current_user.bulk_importers?
      can [:edit], ActiveFedora::Base
    end

    def can_import_works?
      current_user.admin? || (current_user.bulk_importers? && current_user.agency_submitters?)
    end

    def can_export_works?
      current_user.admin?
    end

    # Limits creating new objects to a specific group
    #
    # if user_groups.include? 'special_group'
    #   can [:create], ActiveFedora::Base
    # end
  end
end
