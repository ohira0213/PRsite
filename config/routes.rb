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
    get 'homes/about' => 'homes#about',as: '/about'
    resources :posts, only: [:new, :create, :index, :show, :destroy]
    resources :users, only: [:show, :edit, :update]
  end
end
