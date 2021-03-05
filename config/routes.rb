Rails.application.routes.draw do
  mount LetterOpenerWeb::Engine, at: '/letter_opener' # if Rails.env.development?
  get 'password_resets/create'
  get 'password_resets/edit'
  get 'password_resets/update'
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
  resources :bookmarks, only: %i[create destroy]
  resource :profile, only: %i[show edit update]
  resources :password_resets, only: %i[create edit update new]

  namespace :admin do
    root to: 'dashboards#index'
    get 'login' => 'user_sessions#new'
    post 'login' => 'user_sessions#create'
    delete 'login' => 'user_sessions#destroy'

    resources :users
    resources :boards
  end
end
