class LoginController < ApplicationController
  def login
    sign_in_and_redirect User.find_by(:email =>"test@records.nyc.gov")
  end
end

