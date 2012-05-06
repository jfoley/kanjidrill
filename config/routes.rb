KanjiDrill::Application.routes.draw do
  devise_for :users, :controllers => {
    :sessions => 'sessions'
  }

  resources :grades, :only => [:index, :show]
  resources :checks, :only => :create

  resource :dashboard, :controller => :dashboard, :only => :show

  resource :home, :controller => :home, :only => :index
  match '/about' => 'home#about', :as => :about

  match '/s3_policy' => 'avatar#s3_policy'
  match '/fetch_avatar' => 'avatar#fetch_avatar'
  match '/poll_avatar' => 'avatar#poll'

  root :to => 'home#index'
end
