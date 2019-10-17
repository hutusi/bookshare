Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'home#index'

  scope 'api', defaults: { format: :json } do
    # only sessions 
    devise_for :users, only: [:sessions]
  end

  namespace 'api', as: 'api', defaults: { format: :json } do
    scope 'v1' do
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
        end

        member do
          put :property, to: 'print_books#update_property'
          put :status, to: 'print_books#update_status'
        end
      end
      
      resources :deals
      resources :sharings, only: [:index, :show, :create, :update, :destroy] do 
        member do
          post :request, to: 'sharings#create_request'
          post :reject, to: 'sharings#create_reject'
          post :share, to: 'sharings#create_share'
          delete :share, to: 'sharings#destroy_share'
          post :accept, to: 'sharings#create_accept'
        end
      end
    end
  end
end
