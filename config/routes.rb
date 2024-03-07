Rails.application.routes.draw do
  devise_for :admin, controllers: {
    sessions: "admin/sessions"
  }

  devise_for :user, controllers: {
    registrations: 'public/registrations',
    sessions: 'public/sessions'
  }

  namespace :admin do
    root to: 'homes#top'
  end

  namespace :public, path: '' do
    root to: 'homes#top'
    resources :posts, only: [:new, :create, :index, :show, :destroy] do
      resource :favorites, only: [:create, :destroy]
    end
    resources :users, only: [:show, :edit, :update] do
      get 'withdrawal', to: 'users#withdrawal', as: 'withdrawal'
    end
  end
end
