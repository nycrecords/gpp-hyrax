# Generated via
#  `rails generate hyrax:work NycGovernmentPublication`
class NycGovernmentPublicationIndexer < Hyrax::WorkIndexer
  # This indexes the default metadata. You can remove it if you want to
  # provide your own metadata and indexing.
  include Hyrax::IndexesBasicMetadata

  # Fetch remote labels for based_near. You can remove this if you don't want
  # this behavior
  include Hyrax::IndexesLinkedMetadata

  # Uncomment this block if you want to add custom indexing behavior:
  def generate_solr_document
   super.tap do |solr_doc|
     solr_doc['title_ssi'] = object.title
     solr_doc['agency_ssi'] = object.agency
     solr_doc['date_published_ssi'] = object.date_published
     solr_doc['all_text_timv'] = extract_text_from_filesets
   end
  end

  def extract_text_from_filesets
    object.file_sets.map do |file_set|
      file_set.extracted_text&.content
    end.compact.join(" ")
  end
end