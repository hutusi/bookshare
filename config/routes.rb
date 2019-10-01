Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  namespace 'api', as: 'api' do
    resources :print_books
    resources :deals
  end
end
