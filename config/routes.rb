Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'home#index'

  require 'sidekiq/web'
  mount Sidekiq::Web => '/admin/sidekiq'

  scope 'api', defaults: { format: :json } do
    # only sessions 
    devise_for :users, only: [:sessions]
  end

  namespace 'api', as: 'api', defaults: { format: :json } do
    scope 'v1' do

      namespace :base do
        get :test
      end

      resources :sessions, only: [] do
        collection do
          post :wechat, to: 'sessions#create_wechat'
        end
      end

      resources :users, only: [:index, :show, :update]

      namespace :shelfs do
        get :summary
        get :shared
        get :lent
        get :received
        get :borrowed
        get :personal
      end

      namespace :dashboard do
        get :index
      end

      resources :books, only: [:index, :show, :create, :update, :destroy] do
        collection do
          get 'isbn/:isbn', to: 'books#isbn'
        end
      end

      resources :print_books, only: [:index, :show, :create, :update, :destroy] do
        collection do
          get :for_share
          get :for_borrow

          get :search_by
        end

        member do
          put :property, to: 'print_books#update_property'
          put :status, to: 'print_books#update_status'
        end
      end
      
      resources :deals
      resources :sharings, only: [:index, :show, :create] do 
        member do
          post :accept, to: 'sharings#accept'
          post :reject, to: 'sharings#reject'
          post :lend, to: 'sharings#lend'
          post :borrow, to: 'sharings#borrow'
        end
      end
    end
  end
end
