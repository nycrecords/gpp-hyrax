module Hyrax
  class WorkflowActionsController < ApplicationController
    before_action :authenticate_user!

    def update
      if workflow_action_form.save
        update_required_report(workflow_action_form.work, workflow_action_form.name)

        after_update_response
      else
        respond_to do |wants|
          wants.html { render 'hyrax/base/unauthorized', status: :unauthorized }
          wants.json { render_json_response(response_type: :unprocessable_entity, options: { errors: curation_concern.errors }) }
        end
      end
    end

    private

    def curation_concern
      @curation_concern ||= ActiveFedora::Base.find(params[:id])
    end

    def workflow_action_form
      @workflow_action_form ||= Hyrax::Forms::WorkflowActionForm.new(
        current_ability: current_ability,
        work: curation_concern,
        attributes: workflow_action_params
      )
    end

    def workflow_action_params
      params.require(:workflow_action).permit(:name, :comment)
    end

    def after_update_response
      respond_to do |wants|
        wants.html { redirect_to [main_app, curation_concern], notice: "The #{curation_concern.human_readable_type} has been updated." }
        wants.json { render 'hyrax/base/show', status: :ok, location: polymorphic_path([main_app, curation_concern]) }
      end
    end

    # Update required_report and required_report_due_date values given a work and workflow action
    def update_required_report(work, workflow_action_name)
      required_report_name = work.required_report_name
      return if required_report_name == 'Not Required'

      date_published = Date.parse(work.date_published)
      # Find all required reports for the specified agency and name
      required_reports = RequiredReport.where(agency_name: work.agency, name: required_report_name)
      # Search for a required report with no end_date. If none, select the first report found
      required_report = required_reports.find_by(end_date: nil) || required_reports.first

      case workflow_action_name
      when 'comment_only'
        return
      when 'approve'
        # Set last_published_date if work is approved and date_published is after current value of last_published_date
        if required_report.last_published_date.nil? || (date_published > required_report.last_published_date)
          required_report.update(last_published_date: date_published)
        end
      when 'request_changes'
        # Set date_submitted to nil on request_changes
        required_report_due_date = RequiredReportDueDate.where(submission_id: work.id).first
        required_report_due_date&.update(date_submitted: nil)
      when 'request_review'
        # Set date_submitted to current date and time on request_review
        required_report_due_date = RequiredReportDueDate.where(submission_id: work.id).first
        required_report_due_date&.update(date_submitted: Time.current)
      end
    end
  end
end
