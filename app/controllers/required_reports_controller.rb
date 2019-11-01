class RequiredReportsController < ApplicationController
  before_action :set_required_report, only: [:show, :edit, :update, :destroy]

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
  def edit
  end

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
  def update
    respond_to do |format|
      if @required_report.update(required_report_params)
        format.html { redirect_to @required_report, notice: 'Required report was successfully updated.' }
        format.json { render :show, status: :ok, location: @required_report }
      else
        format.html { render :edit }
        format.json { render json: @required_report.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /required_reports/1
  # DELETE /required_reports/1.json
  def destroy
    @required_report.destroy
    respond_to do |format|
      format.html { redirect_to required_reports_url, notice: 'Required report was successfully destroyed.' }
      format.json { head :no_content }
    end
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
