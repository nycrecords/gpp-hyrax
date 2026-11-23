# frozen_string_literal: true
module Hyrax
  class UsersController < ApplicationController
    include Blacklight::SearchContext
    prepend_before_action :find_user, only: [:show]

    helper Hyrax::TrophyHelper

    def index
      # [gpp-override] resolve the flag without the client-settable cookie
      authenticate_user! if Gpp::FeatureFlag.enabled?(:hide_users_list)
      @users = search(params[:uq])
    end

    # Display user profile
    def show
      user = ::User.from_url_component(params[:id])
      return redirect_to root_path, alert: "User '#{params[:id]}' does not exist" if user.nil?
      @presenter = Hyrax::UserProfilePresenter.new(user, current_ability)
    end

    private

    # TODO: this should move to a service.
    # Returns a list of users excluding the system users and guest_users
    # @param query [String] the query string
    def search(query)
      clause = query.blank? ? nil : "%" + query.downcase + "%"
      base = ::User.where(*base_query)
      base = base.where("#{Hydra.config.user_key_field} like lower(?) OR display_name like lower(?)", clause, clause) if clause.present?
      base.registered
          .where("#{Hydra.config.user_key_field} not in (?)",
                 [::User.batch_user_key, ::User.audit_user_key])
          .references(:trophies)
          .order(sort_value)
          .page(params[:page]).per(10)
    end

    # You can override base_query to return a list of arguments
    def base_query
      [nil]
    end

    def find_user
      @user = ::User.from_url_component(params[:id])
      redirect_to root_path, alert: "User does not exist" unless @user
    end

    # [gpp-override] stop params[:sort] reaching ORDER BY
    # Only the four sorts the view offers; anything else uses the default
    def sort_value
      case params[:sort]
      when 'name desc'
        'display_name DESC'
      when 'login'
        Hydra.config.user_key_field
      when 'login desc'
        "#{Hydra.config.user_key_field} DESC"
      else
        'display_name'
      end
    end
  end
end