Rails.application.routes.draw do

  mount Bulkrax::Engine, at: '/'
  mount Riiif::Engine => 'images', as: :riiif if Hyrax.config.iiif_image_server?
  mount Blacklight::Engine => '/'
  mount BlacklightAdvancedSearch::Engine => '/'

    concern :searchable, Blacklight::Routes::Searchable.new

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

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

  resources :required_reports do
    collection do
      get 'agency_required_reports'
      get 'public_list'
    end
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
