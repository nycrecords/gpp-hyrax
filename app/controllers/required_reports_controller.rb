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
    @required_report_names = []
    @agency = params[:agency]
    @required_reports = RequiredReportDueDate.select(Arel.star).where(
        RequiredReport.arel_table[:agency_name].eq(@agency).and(
            RequiredReportDueDate.arel_table[:date_submitted].eq(nil)
        )
    ).joins(
        RequiredReportDueDate.arel_table.join(RequiredReport.arel_table).on(
            RequiredReportDueDate.arel_table[:required_report_id].eq(RequiredReport.arel_table[:id])
        ).join_sources
    )
    @required_reports.each do |required_report|
      @required_report_names << { 'report_name': required_report.name, 'due_date': required_report.due_date }
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
