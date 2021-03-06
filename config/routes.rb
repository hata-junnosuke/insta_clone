Rails.application.routes.draw do
  # sinatraのダッシュボードを使うためrequire
  require 'sidekiq/web'

  root 'posts#index'

  # 公式で設定することが記述
  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: '/letter_opener'
    # sidekiqのダッシュボード（sinatra）
    mount Sidekiq::Web, at: '/sidekiq'
  end
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
    resource :notification_setting, only: %i[edit update]
  end
end
