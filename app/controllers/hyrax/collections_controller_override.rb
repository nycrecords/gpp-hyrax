# Generated via
#  `rails generate hyrax:work NycGovernmentPublication`
module Hyrax
  # Generated controller for NycGovernmentPublication
  module CollectionsControllerOverride
    # Adds Hyrax behaviors to the controller.
    def self.prepended(base)
      base.form_class = Hyrax::CollectionForm
    end
  end
end