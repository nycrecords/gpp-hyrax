module Hyrax
  class WorkflowActionsController < ApplicationController
    before_action :authenticate_user!

    def update
      if workflow_action_form.save
        update_required_report(workflow_action_form.work, workflow_action_form.name)
        set_public_visibility(workflow_action_form.work, workflow_action_form.name)

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

    def set_public_visibility(work, workflow_action_name)
      if workflow_action_name == 'approve'
        work.visibility = Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC
        work.save!
        VisibilityCopyJob.perform_later(work)
        InheritPermissionsJob.perform_later(work)
      end
    end

    # Update required_report and required_report_due_date values given a work and workflow action
    def update_required_report(work, workflow_action_name)
      required_report_name = work.required_report_name
      return if ['Not Required', 'Other Publication'].include?(required_report_name)

      Gpp::UpdateMandatedReportJob.perform_later(work.id, workflow_action_name)
    end
  end
end
