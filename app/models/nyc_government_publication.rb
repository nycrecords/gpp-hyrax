# Generated via
#  `rails generate hyrax:work NycGovernmentPublication`
class NycGovernmentPublication < ActiveFedora::Base
  include Hyrax::WorkBehavior
  include ::NycGovernmentPublicationsMetadata

  self.human_readable_type = 'NYC Government Publication'

  self.indexer = NycGovernmentPublicationIndexer
  # Change this to restrict which works can be added as a child.
  # self.valid_child_concerns = []
  validates :title, presence: { message: 'Your work must have a title.' }

  # This must be included at the end, because it finalizes the metadata
  # schema (by adding accepts_nested_attributes)
  include ::Hyrax::BasicMetadata
end
