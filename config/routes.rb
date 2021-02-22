Rails.application.routes.draw do
  root to: 'static_pages#top'
  resources :users
  resources :boards do
    resources :comments, only: %i[create destroy], shallow: true
  end

  get 'login' => 'user_sessions#new', :as => :login
  post 'login' => 'user_sessions#create'
  delete 'logout' => 'user_sessions#destroy', :as => :logout
end
