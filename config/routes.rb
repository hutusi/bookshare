Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  namespace 'api', as: 'api' do
    resources :print_books, only: [:index, :show, :create, :update, :destroy] do
      member do
        put :property, to: 'print_books#update_property'
        put :status, to: 'print_books#update_status'
      end
    end
    resources :deals
  end
end
