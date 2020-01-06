module Hyrax
  class WorkflowActionsController < ApplicationController
    before_action :authenticate_user!

    def update
      if workflow_action_form.save
        work = workflow_action_form.work
        required_report_name = work.required_report_name

        if (workflow_action_form.name == 'approve') && (required_report_name != 'Not Required')
          required_report = RequiredReport.where(agency_name: work.agency, name: required_report_name).first
          required_report.update_attributes(last_published_date: work.date_published)
        end

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
  end
end
