class AgencyContactsController < ApplicationController
  include Hyrax::ThemedLayoutController
  before_action :authenticate_user!
  before_action :ensure_authorized!
  before_action :set_agency, only: [:edit, :create, :destroy]
  with_themed_layout 'dashboard'

  def index
    @agencies = Agency.all
    add_agency_breadcrumbs
  end

  def edit
    @emails = @agency.point_of_contact_emails || []
    add_agency_breadcrumbs
    add_breadcrumb "Edit", edit_agency_contact_path(@agency)
  end

  def create
    email = params[:new_email].to_s.downcase.strip

    if !valid_email?(email)
      return render json: { error: "Invalid email address." }, status: :unprocessable_entity
    elsif @agency.point_of_contact_emails&.include?(email)
      return render json: { error: "Email already exists." }, status: :unprocessable_entity
    end

    @agency.point_of_contact_emails << email

    if @agency.save
      render_email_rows(message: "Email added successfully")
    else
      render json: { error: "Failed to save email." }, status: :unprocessable_entity
    end
  end

  def destroy
    indices = Array(params[:indices]).map(&:to_i)
    emails = @agency.point_of_contact_emails || []

    # Reverse sort the indices to ensure shifting doesn't change the index of the email we're removing
    indices.sort.reverse.each do |index|
      emails.delete_at(index)
    end

    if @agency.update(point_of_contact_emails: emails)
      render_email_rows(message: "Selected email(s) have been successfully removed.")
    else
      render json: { error: "Failed to delete email(s)." }, status: :unprocessable_entity
    end
  end

  private

  def set_agency
    @agency = Agency.find(params[:id])

    if @agency.point_of_contact_emails.nil?
      @agency.point_of_contact_emails = []
    end

    @emails = @agency.point_of_contact_emails
  end

  def valid_email?(email)
    # Ensure the email does not contain any spaces
    return false if email.blank? || email.match?(/\s/)

    # Validate using the general EMAIL_REGEXP
    return false unless email.match?(URI::MailTo::EMAIL_REGEXP)

    # Check for the presence of a domain
    domain_regex = /\A[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*\.[a-zA-Z]{2,}\z/
    domain = email.split('@').last
    domain.match?(domain_regex)
  end

  def render_email_rows(message: nil)
    render json: {
      html: render_to_string(partial: 'agency_contacts/email_rows',locals: { emails: @emails, agency: @agency }),
      message: message
    }
  end

  def add_agency_breadcrumbs
    add_breadcrumb t(:'hyrax.controls.home'), main_app.root_path
    add_breadcrumb t(:'hyrax.dashboard.breadcrumbs.admin'), hyrax.dashboard_path
    add_breadcrumb t(:'hyrax.admin.sidebar.agency_contacts'), main_app.agency_contacts_path
  end

  def ensure_authorized!
    authorize! :review, :submissions
  end
end
