# frozen_string_literal: true

class RequiredReportsController < ApplicationController
  load_and_authorize_resource except: :public_list
  # Removed :edit, :update, :destroy actions from 'only' for now
  before_action :set_required_report, only: [:show]

  # GET /required_reports
  # GET /required_reports.json
  def index
    if params[:per_page].nil?
      params[:per_page] = 20
    end

    if params[:agency].nil?
      params[:agency] = 'All'
    end

    if params[:agency] == 'All' or params[:agency].nil?
      @required_reports = RequiredReport.all.order(agency_name: :asc, name: :asc).page(params[:page]).per(params[:per_page])
    else
      @required_reports = RequiredReport.where(agency_name: params[:agency]).order(name: :asc).page(params[:page]).per(params[:per_page])
    end

    @agencies = Agency.all.order(name: :asc)
  end

  # GET /required_reports/1
  # GET /required_reports/1.json
  def show
  end

  # GET /required_reports/new
  def new
    @required_report = RequiredReport.new
  end

  # GET /required_reports/1/edit
  # def edit
  # end

  # POST /required_reports
  # POST /required_reports.json
  def create
    start_date = Date.parse(required_report_params[:start_date]) rescue nil
    end_date = Date.parse(required_report_params[:end_date]) rescue nil
    automated_date = required_report_params[:automated_date]
    # Get attributes for RequiredReportDueDate.
    due_date_attributes = RequiredReportDueDate.new.generate_due_date_attributes(required_report_params[:frequency],
                                                                                 required_report_params[:frequency_integer],
                                                                                 start_date,
                                                                                 end_date,
                                                                                 automated_date)

    # Return new RequiredReport object with required_report_due_dates_attributes added to params.
    @required_report = RequiredReport.new(required_report_params.merge(required_report_due_dates_attributes:
                                                                         due_date_attributes))

    respond_to do |format|
      if @required_report.save
        path = mandated_report_path(@required_report)

        format.html { redirect_to path, notice: 'Mandated Report was successfully created.' }
        format.json { render :show, status: :created, location: path }
      else
        format.html { render :new }
        format.json { render json: @required_report.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /required_reports/1
  # PATCH/PUT /required_reports/1.json
  # def update
  #   respond_to do |format|
  #     if @required_report.update(required_report_params)
  #       format.html { redirect_to @required_report, notice: 'Required report was successfully updated.' }
  #       format.json { render :show, status: :ok, location: @required_report }
  #     else
  #       format.html { render :edit }
  #       format.json { render json: @required_report.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # DELETE /required_reports/1
  # DELETE /required_reports/1.json
  # def destroy
  #   @required_report.destroy
  #   respond_to do |format|
  #     format.html { redirect_to required_reports_url, notice: 'Required report was successfully destroyed.' }
  #     format.json { head :no_content }
  #   end
  # end

  # GET /required_reports/agency_required_reports
  def agency_required_reports
    @required_report_names = []
    @agency = params[:agency]

    @required_reports = RequiredReportDueDate.includes(:required_report)
                            .where(date_submitted: nil)
                            .where('required_reports.agency_name = ?', @agency)
                            .order('required_reports.name ASC, base_due_date ASC')
                            .references(:required_reports)

    @required_reports.each do |required_report|
      @required_report_names << { 'report_name': required_report.required_report.name,
                                  'base_due_date': required_report.base_due_date,
                                  'report_due_date_id': required_report.id }
    end
    render json: { 'required_report_names': @required_report_names }
  end

  # GET /required_reports/public_list
  def public_list
    params[:per_page] ||= 20
    params[:agency] ||= 'All'

    # Determine if the current user is an admin
    @is_admin = user_signed_in? && (current_user.admin? || current_user.library_reviewers?)

    # Build the base query with visibility conditions based on user role
    base_query = if @is_admin
                   RequiredReport.all
                 else
                   RequiredReport.where(is_visible: true)
                 end

    # Apply agency filter to the base query
    @required_reports = if params[:agency] == 'All'
                          base_query.order(agency_name: :asc, name: :asc)
                        else
                          base_query.where(agency_name: params[:agency]).order(name: :asc)
                        end

    # Apply pagination
    @required_reports = @required_reports.page(params[:page]).per(params[:per_page])

    # Fetch agencies for the dropdown
    @agencies = Agency.all.order(name: :asc)
  end

  def toggle_visibility
    if @required_report.update(is_visible: params[:required_report][:is_visible])
      render json: { success: true }
    else
      render json: { success: false, error: @required_report.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_required_report
      @required_report = RequiredReport.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def required_report_params
      params.require(:required_report).permit(:agency_name, :name, :description, :local_law, :charter_and_code, :automated_date, :frequency, :frequency_integer, :other_frequency_description, :start_date, :end_date, :last_published_date, :required_distribution, :report_deadline, :additional_notes, :is_visible)
    end
end
