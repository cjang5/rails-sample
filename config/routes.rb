Rails.application.routes.draw do
  get 'sessions/new'

  get 'rails/generate'

  get 'rails/controller'

  get 'rails/Sessions'

  get 'rails/new'

  root             'static_pages#home'
  get 'help'    => 'static_pages#help'
  get 'about'   => 'static_pages#about'
  get 'contact' => 'static_pages#contact'

  get 'signup' => 'users#new'

  # provide users resource
  resources :users

  # Session routes
  get    'login'  => 'sessions#new'
  post   'login'  => 'sessions#create'
  delete 'logout' => 'sessions#destroy'
end
