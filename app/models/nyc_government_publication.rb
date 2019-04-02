# Generated via
#  `rails generate hyrax:work NycGovernmentPublication`
class NycGovernmentPublication < ActiveFedora::Base
  include ::Hyrax::WorkBehavior

  # This must come after the WorkBehavior because it finalizes the metadata
  # schema (by adding accepts_nested_attributes)
  include ::NycGovernmentPublicationMetadata
  include ::Hyrax::BasicMetadata

  self.indexer = NycGovernmentPublicationIndexer
  # Change this to restrict which works can be added as a child.
  # self.valid_child_concerns = []
  validates :title, presence: { message: 'Publication title is required. Please enter a title.' }
  validates :agency, presence: { message: 'Agency is required. Please select an agency.'}
  validates :subject, presence: { message: 'Subject is required. Please select at least one subject.'},
            length: {minimum: 1, maximum: 3}
  validates :description, presence: { message: 'Description is required. Please enter a description.'}
  validates :date_issued, presence: { message: 'Date Published is required. Please enter the date published.'}
  validates :type, presence: { message: 'Report Type is required. Please select a report type.'}

  self.human_readable_type = 'Government Publication'
  self.human_readable_short_description = 'NYC Government Agency Publication submitted to DORIS'
end
