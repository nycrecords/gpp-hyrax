# frozen_string_literal: true
class SolrDocument
  include Blacklight::Solr::Document
  include Blacklight::Gallery::OpenseadragonSolrDocument

  # Adds Hyrax behaviors to the SolrDocument.
  include Hyrax::SolrDocumentBehavior


  # self.unique_key = 'id'

  # Email uses the semantic field mappings below to generate the body of an email.
  SolrDocument.use_extension(Blacklight::Document::Email)

  # SMS uses the semantic field mappings below to generate the body of an SMS email.
  SolrDocument.use_extension(Blacklight::Document::Sms)

  # DublinCore uses the semantic field mappings below to assemble an OAI-compliant Dublin Core document
  # Semantic mappings of solr stored fields. Fields may be multi or
  # single valued. See Blacklight::Document::SemanticFields#field_semantics
  # and Blacklight::Document::SemanticFields#to_semantic_values
  # Recommendation: Use field names from Dublin Core
  use_extension(Blacklight::Document::DublinCore)

  # Do content negotiation for AF models. 

  use_extension( Hydra::ContentNegotiation )

  def sub_title
    self[Solrizer.solr_name('sub_title')]
  end

  def agency
    self[Solrizer.solr_name('agency')][0]
  end

  def report_type
    self[Solrizer.solr_name('report_type')]
  end

  def date_published
    self[Solrizer.solr_name('date_published')][0]
  end

  def additional_creators
    self[Solrizer.solr_name('additional_creators')]
  end

  def fiscal_year
    self[Solrizer.solr_name('fiscal_year')]
  end

  def calendar_year
    self[Solrizer.solr_name('calendar_year')]
  end

  def borough
    self[Solrizer.solr_name('borough')]
  end

  def school_district
    self[Solrizer.solr_name('school_district')]
  end

  def community_board_district
    self[Solrizer.solr_name('community_board_district')]
  end

  def associated_place
    self[Solrizer.solr_name('associated_place')]
  end

  def required_report_name
    self[Solrizer.solr_name('required_report_name')]
  end
end
