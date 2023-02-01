class LoginController < ApplicationController
  before_action :restrict_to_development

  def create
    @user = User.find_by(:email => params[:email])
    @user ? (sign_in_and_redirect @user) :  (redirect_to login_index_path, notice: "User Not Found")
  end
end

private

def restrict_to_development
  raise ActionController::RoutingError.new('Not Found') unless ActiveModel::Type::Boolean.new.cast(ENV['LOCAL_LOGIN'])
end

