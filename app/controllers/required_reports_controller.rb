class RequiredReportsController < ApplicationController
  load_and_authorize_resource
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
    @required_report = RequiredReport.new(required_report_params)

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
    @report_names = []
    @agency = params[:agency]
    @reports = RequiredReport.where(agency: @agency)
    @reports.each do |report|
      @report_names << report.name
    end
    render json: { 'report_names': @report_names }
  end

  # GET /required_reports/public_list
  def public_list
    @search_reports = []
    @required_reports = RequiredReport.all.order(agency: :asc, name: :asc)
    @required_reports.each do |report|
      if report.frequency != 'Once'
        if report.frequency_integer == 1
          report.frequency = report.frequency.delete_suffix('s')
        end
        report.frequency = report.frequency.sub('X', report.frequency_integer.to_s)
      end
    end
    @search_url = [
        root_url.delete_suffix('?locale=en') + 'catalog?additional_creators=&agency=',
        '&all_fields=&associated_place=&borough=&calendar_year=&community_board_district=&date_published=&description=&fiscal_year=&language=&locale=en&op=AND&report_type=&required_report_name=',
        '&school_district=&search_field=advanced&sort=date_published_ssi+desc&sub_title=&subject=&title='
    ]
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_required_report
      @required_report = RequiredReport.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def required_report_params
      params.require(:required_report).permit(:agency, :name, :description, :local_law, :charter_and_code, :frequency, :frequency_integer, :other_frequency_description, :start_date, :end_date, :last_published_date)
    end
end
