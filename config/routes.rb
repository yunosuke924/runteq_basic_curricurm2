Rails.application.routes.draw do
  root to: 'static_pages#top'

  get 'login' => 'user_sessions#new', :as => :login
  post 'login' => 'user_sessions#create'
  delete 'logout' => 'user_sessions#destroy', :as => :logout
  # post '/boards/:id' => 'boards#create'

  resources :users, only: %i[new create]
  resources :boards, only: %i[index new create show] do
    resources :comments, only: %i[create destroy], shallow: true
  end
end
