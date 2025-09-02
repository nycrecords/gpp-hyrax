class AgencyAliasesController < ApplicationController
  include Hyrax::ThemedLayoutController
  before_action :authenticate_user!
  before_action :ensure_authorized!
  include Gpp::SetAgency
  include Gpp::AgencyPartialRowsRenderer
  with_themed_layout 'dashboard'

  def index
    @agencies = Agency.includes(:aliases).order(:name)
    add_agency_breadcrumbs
  end

  def edit
    set_agency_list
    add_agency_breadcrumbs
    add_breadcrumb "Edit Aliases", edit_agency_alias_path(@agency)
  end

  def create
    alias_id = params[:new_item].to_s.strip

    if alias_id.blank?
      return render json: { error: "Alias name cannot be blank." }, status: :unprocessable_entity
    end

    alias_agency = Agency.find_by(id: alias_id)

    if alias_agency.nil?
      return render json: { error: "No agency exists with that ID." }, status: :unprocessable_entity
    elsif @agency.aliases.include?(alias_agency)
      return render json: { error: "Alias already exists." }, status: :unprocessable_entity
    elsif alias_agency == @agency
      return render json: { error: "Cannot alias an agency to itself." }, status: :unprocessable_entity
    end

    agency_alias = @agency.outgoing_aliases.build(alias_agency: alias_agency)

    if agency_alias.save
      set_agency_list
      render_alias_rows(message: "Alias added successfully")
    else
      render json: { error: "Failed to save alias." }, status: :unprocessable_entity
    end
  end

  def destroy
    indices = Array(params[:indices]).map(&:to_i)
    alias_ids = @agency.aliases.pluck(:id)
    ids_to_remove = alias_ids.values_at(*indices)

    AgencyAlias.where(primary_agency: @agency, alias_agency_id: ids_to_remove).destroy_all

    set_agency_list
    render_alias_rows(message: "Selected alias(es) removed.")
  end

  private

  def set_agency_list
    @aliases = @agency.aliases.map(&:name)
    excluded_ids = @agency.aliases.pluck(:id) + [@agency.id]
    @agencies_list = Agency.where.not(id: excluded_ids).order(:name)
  end

  def render_alias_rows(message: nil)
    render_rows partial: 'shared/agency_item_rows',
                locals: { items: @agency.aliases.map(&:name), table:'aliases' },
                message: message,
                options: {
                  options_html: render_to_string(
                    partial: 'agency_select_options',
                    locals: { agencies_list: @agencies_list },
                    formats: [:html])
                }
  end

  def add_agency_breadcrumbs
    add_breadcrumb t(:'hyrax.controls.home'), main_app.root_path
    add_breadcrumb t(:'hyrax.dashboard.breadcrumbs.admin'), hyrax.dashboard_path
    add_breadcrumb "Manage Aliases", main_app.agency_aliases_path
  end

  def ensure_authorized!
    authorize! :review, :submissions
  end
end
