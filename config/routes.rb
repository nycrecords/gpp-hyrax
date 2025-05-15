# frozen_string_literal: true
Rails.application.routes.draw do
  mount Bulkrax::Engine, at: '/'
  mount Riiif::Engine => 'images', as: :riiif if Hyrax.config.iiif_image_server?

  match '/404', to: 'errors#not_found', via: :all
  match '/500', to: 'errors#internal_server_error', via: :all

  authenticate :user, ->(u) { u.admin? } do
    require 'sidekiq/web'
    require 'sidekiq-status/web'
    mount Sidekiq::Web => '/sidekiq'
  end

  # [gpp-override] Remove blacklight routes, e.g. suggest, saved_searches, search_history
  match 'search_history', to: 'errors#not_found', via: :all
  match 'saved_searches', to: 'errors#not_found', via: :all
  get 'suggest', to: 'errors#not_found'

  mount Blacklight::Engine => '/'
  mount BlacklightAdvancedSearch::Engine => '/'

  concern :searchable, Blacklight::Routes::Searchable.new

  resource :catalog, only: [:index], as: 'catalog', path: '/catalog', controller: 'catalog' do
    concerns :searchable
  end

  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  devise_scope :user do
    get 'sign_out', to: 'sessions#destroy', as: :destroy_user_session
    get 'active' => 'sessions#active'
    get 'timeout' => 'sessions#timeout'
    get 'renew_session' => 'sessions#renew'
  end

  # Route for development login
  resources :login

  mount Hydra::RoleManagement::Engine => '/'

  mount Qa::Engine => '/authorities'
  mount Hyrax::Engine, at: '/'
  resources :welcome, only: 'index'
  root 'hyrax/homepage#index'
  curation_concerns_basic_routes
  concern :exportable, Blacklight::Routes::Exportable.new

  resources :solr_documents, only: [:show], path: '/catalog', controller: 'catalog' do
    concerns :exportable
  end

  resources :bookmarks do
    concerns :exportable

    collection do
      delete 'clear'
    end
  end

  resources :mandated_reports, controller: 'required_reports' do
    collection do
      get 'agency_required_reports'
      get 'public_list'
    end

    member do
      patch 'toggle_visibility'
    end
  end

  # Catch all route for any routes that don't exist. Always have this as the last route
  match '*path', to: 'errors#not_found', via: :all, format: false, defaults: { format: 'html' }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
