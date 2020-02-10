# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationController do
  let(:user) do
    User.new(email: 'test@example.com') { |u| u.save!(validate: false) }
  end

  describe 'After sign-in' do
    it 'redirects to homepage' do
      controller.after_sign_in_path_for(user).should == root_path
    end
  end
end
