Rails.application.routes.draw do
  root 'posts#index'

  get 'login', to: 'user_sessions#new'
  post 'login', to: 'user_sessions#create'
  delete 'logout', to: 'user_sessions#destroy'

  resources :users, only: %i[index new create show]
  # shallowルーティング
  resources :posts, shallow: true do
    # これによりposts/search
    collection do
      get :search
    end
    resources :comments
  end

  resources :likes, only: %i[create destroy]
  resources :relationships, only: %i[create destroy]

  resources :activities, only: [] do
    patch :read, on: :member
  end

  namespace :mypage do
    resource :account, only: %i[edit update]
    resources :activities, only: %i[index]
  end

  constraints ->(request) { request.session[:user_id].present? } do
    # ログインしてる時のルートパス
    root 'posts#index'
  end
  # ログインしてない時のルートパス
  root 'user_sessions#new'
end
