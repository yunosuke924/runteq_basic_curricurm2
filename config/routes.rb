Rails.application.routes.draw do
  root to: 'static_pages#top'

  get 'login' => 'user_sessions#new', :as => :login
  post 'login' => 'user_sessions#create'
  delete 'logout' => 'user_sessions#destroy', :as => :logout

  resources :users, only: %i[new create]
  resources :boards, only: %i[index new create show edit update destroy] do
    resources :comments, only: %i[create destroy], shallow: true

    collection do
      get :bookmarks
    end
  end

  resources :bookmarks, only: %i[ create destroy]
end
