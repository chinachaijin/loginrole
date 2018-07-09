Rails.application.routes.draw do

  root :to => 'logins#index'

  resources :logins do
    collection do
      post "loginuser"
    end
  end
  resources :roles
  resources :userroles
  resources :users
  resources :privileges
  resources :modulars
  resources :modularprivileges
  resources :rolemodulars

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
