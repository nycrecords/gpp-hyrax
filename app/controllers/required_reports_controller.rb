# frozen_string_literal: true

class RequiredReportsController < ApplicationController
  load_and_authorize_resource except: :public_list
  # Removed :edit, :update, :destroy actions from 'only' for now
  before_action :set_required_report, only: [:show]

  # GET /required_reports
  # GET /required_reports.json
  def index
    @required_reports = RequiredReport.all
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
    frequency = required_report_params['frequency']
    frequency_integer = required_report_params['frequency_integer'].to_i
    start_date = Date.parse(required_report_params['start_date'])
    end_date = Date.parse(required_report_params['end_date']) unless required_report_params['end_date'].blank?

    # Get attributes for RequiredReportDueDate.
    due_date_attributes = RequiredReportDueDate.new.generate_due_date_attributes(frequency,
                                                                                 frequency_integer,
                                                                                 start_date,
                                                                                 end_date)

    # Return new RequiredReport object with required_report_due_dates_attributes added to params.
    @required_report = RequiredReport.new(required_report_params.merge(required_report_due_dates_attributes:
                                                                         due_date_attributes))

    respond_to do |format|
      if @required_report.save
        format.html { redirect_to @required_report, notice: 'Required report was successfully created.' }
        format.json { render :show, status: :created, location: @required_report }
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
    @required_reports = RequiredReport.where(agency_name: @agency)
    @required_reports.each do |required_report|
      @required_report_names << required_report.name
    end
    render json: { 'required_report_names': @required_report_names }
  end

  # GET /required_reports/public_list
  def public_list
    @required_reports = RequiredReport.all.order(agency_name: :asc, name: :asc)
    @search_url = [
        root_url(locale: nil) + 'catalog?utf8=%E2%9C%93&locale=en&agency=',
        '&required_report_name=',
        '&sort=date_published_ssi+desc&search_field=advanced'
    ]
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_required_report
      @required_report = RequiredReport.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def required_report_params
      params.require(:required_report).permit(:agency_name, :name, :description, :local_law, :charter_and_code, :frequency, :frequency_integer, :other_frequency_description, :start_date, :end_date, :last_published_date)
    end
end
