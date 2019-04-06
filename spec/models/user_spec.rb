require 'rails_helper'

describe User, type: :model do
  before do
    described_class.delete_all
  end

  context "saml integration" do
    let(:auth_hash) do
      OmniAuth::AuthHash.new(
          provider: 'saml',
          uid: "janeq",
          info: {
              uid: 'janeq',
              email: 'janeq@example.com'
          },
          extra: {
              response_object:
                  OneLogin::RubySaml::Attributes.new(
                      GUID: 'TestUserGuid',
                      givenName: 'Jane',
                      middleName: 'A',
                      sn: 'Quest',
                      nycExtEmailValidationFlag: true
                  )
          }
      )
    end
    let(:user) {described_class.from_omniauth(auth_hash)}

    before do
      described_class.delete_all
    end

    context "saml" do
      it "has a saml provided name" do
        expect(user.first_name).to eq auth_hash.extra.response_object.attributes[:givenName]
        expect(user.middle_initial).to eq auth_hash.extra.response_object.attributes[:middleName]
        expect(user.last_name).to eq auth_hash.extra.response_object.attributes[:sn]
        expect(user.display_name).to eq "#{auth_hash.extra.response_object.attributes[:givenName]} #{auth_hash.extra.response_object.attributes[:middleName] or ''} #{auth_hash.extra.response_object.attributes[:sn]}"
      end
      it "has a saml provided uid which is not nil" do
        expect(user.uid).to eq auth_hash.info.uid
        expect(user.uid).not_to eq nil
      end
      it "has a saml provided email which is not nil" do
        expect(user.email).to eq auth_hash.info.email
        expect(user.email).not_to eq nil
      end
    end
  end
end
