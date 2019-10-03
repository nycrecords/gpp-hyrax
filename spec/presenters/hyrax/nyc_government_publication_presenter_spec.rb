# frozen_string_literal: true

# Generated via
#  `rails generate hyrax:work NycGovernmentPublication`
require 'rails_helper'

RSpec.describe Hyrax::NycGovernmentPublicationPresenter do
  let(:solr_document) { SolrDocument.new(attributes) }
  let(:ability) { double 'Ability' }
  let(:presenter) { described_class.new(solr_document, ability) }
  let(:attributes) { file.to_solr }

  let(:file) do
    NycGovernmentPublication.new(
      id: '123abc',
      depositor: user.user_key,
      label: 'filename.pdf'
    )
  end
  let(:user) { double(user_key: 'test@example.com') }
  let(:solr_properties) do
    %w[sub_title report_type date_published fiscal_year calendar_year agency additional_creators borough school_district community_board_district associated_place]
  end
  subject { presenter }

  it 'delegate to the solr_document' do
    solr_properties.each do |property|
      expect(solr_document).to receive(property.to_sym)
      presenter.send(property)
    end
  end

  it { is_expected.to delegate_method(:sub_title).to(:solr_document) }
  it { is_expected.to delegate_method(:report_type).to(:solr_document) }
  it { is_expected.to delegate_method(:date_published).to(:solr_document) }
  it { is_expected.to delegate_method(:fiscal_year).to(:solr_document) }
  it { is_expected.to delegate_method(:calendar_year).to(:solr_document) }
  it { is_expected.to delegate_method(:agency).to(:solr_document) }
  it { is_expected.to delegate_method(:additional_creators).to(:solr_document) }
  it { is_expected.to delegate_method(:borough).to(:solr_document) }
  it { is_expected.to delegate_method(:school_district).to(:solr_document) }
  it { is_expected.to delegate_method(:community_board_district).to(:solr_document) }
  it { is_expected.to delegate_method(:associated_place).to(:solr_document) }
end
