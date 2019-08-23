require 'rails_helper'

RSpec.describe User, type: :model do
  context 'saml integration' do
    let(:user_hash) do
      {
        'id' => '1234',
        'firstName' => 'Jane',
        'middleInitial' => 'A',
        'lastName' => 'Doris',
        'email' => 'jdoris@test.com',
        'validated' => true
      }
    end

    let(:user_attributes) do
      {
        guid: 'abc',
        first_name: 'Jane',
        last_name: 'Doriss',
        email: 'jdoris@test.com'
      }
    end

    before do
      described_class.delete_all
    end

    it 'new user has saml provided data' do
      user = described_class.from_omniauth(user_hash)
      expect(user.guid).to eq user_hash['id']
      expect(user.first_name).to eq user_hash['firstName']
      expect(user.middle_initial).to eq user_hash['middleInitial']
      expect(user.last_name).to eq user_hash['lastName']
      expect(user.email).to eq user_hash['email']
      expect(user.email_validated).to eq user_hash['validated']
      expect(user.display_name).to eq "#{user_hash['firstName']} #{user_hash['middleInitial'] || ''} #{user_hash['lastName']}"
    end

    it 'existing user has saml provided data' do
      User.new(user_attributes)
      user = described_class.from_omniauth(user_hash)
      expect(user.guid).to eq user_hash['id']
      expect(user.first_name).to eq user_hash['firstName']
      expect(user.middle_initial).to eq user_hash['middleInitial']
      expect(user.last_name).to eq user_hash['lastName']
      expect(user.email).to eq user_hash['email']
      expect(user.email_validated).to eq user_hash['validated']
      expect(user.display_name).to eq "#{user_hash['firstName']} #{user_hash['middleInitial'] || ''} #{user_hash['lastName']}"
    end
  end
end
