KanjiDrill::Application.routes.draw do
  devise_for :users, :controllers => {
    :sessions => 'sessions'
  }

  resources :grades, :only => [:index, :show]
  resources :checks, :only => :create

  resource :dashboard, :controller => :dashboard, :only => :show

  resource :home, :controller => :home, :only => :index
  match '/about' => 'home#about', :as => :about

  root :to => 'home#index'
end
