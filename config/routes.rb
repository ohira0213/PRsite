Rails.application.routes.draw do
  devise_for :admin, skip: [:registrations, :passwords], controllers: {
    sessions: "admin/sessions"
  }

  devise_for :user, controllers: {
    registrations: 'public/registrations',
    sessions: 'public/sessions'
  }

  devise_scope :user do
    post "public/guest_sign_in", to: "public/sessions#guest_sign_in"
  end

  namespace :admin do
    root to: 'homes#top'
    resources :users, only: [:index, :edit, :update]
  end

  namespace :public, path: '' do
    root to: 'homes#top'
    resources :posts, only: [:new, :create, :index, :show, :destroy] do
      resources :post_comments, only: [:create, :destroy]
      resource :favorites, only: [:create, :destroy]
      #どのfavorite_idか識別の必要がないため単数形（:idがURLに含まれない）
    end
    resources :users, only: [:show, :edit, :update] do
      get 'favorite', to: 'users#favorite', as: 'favorite'
      get 'confirm', to: 'users#confirm', as: 'confirm'
      patch 'withdrawal', to: 'users#withdrawal', as: 'withdrawal'
      resource :relationships, only: [:create, :destroy]
      get "followings" => "relationships#followings", as: "followings"
      get "followers" => "relationships#followers", as: "followers"
    end
    get "search" => "searches#search"
  end
end
