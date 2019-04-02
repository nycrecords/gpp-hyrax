# Generated via
#  `rails generate hyrax:work NycGovernmentPublication`
module Hyrax
  # Generated controller for NycGovernmentPublication
  class NycGovernmentPublicationsController < ApplicationController
    # Adds Hyrax behaviors to the controller.
    include Hyrax::WorksControllerBehavior
    include Hyrax::BreadcrumbsForWorks
    self.curation_concern_type = ::NycGovernmentPublication

    # Use this line if you want to use a custom presenter
    self.show_presenter = Hyrax::NycGovernmentPublicationPresenter
  end
end
