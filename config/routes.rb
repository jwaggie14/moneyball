Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  root :to => "leagues#index"
  
  get "/demo", :controller => "demo", :action => "game"
  
  get "/index", :controller => "users", :action => "home"
  # Routes for the Draft resource:
  # CREATE
  get "/drafts/new", :controller => "drafts", :action => "new"
  post "/create_draft", :controller => "drafts", :action => "create"

  # READ
  get "/drafts", :controller => "drafts", :action => "index"
  get "/drafts/:id", :controller => "drafts", :action => "show"


  # DELETE
  get "/delete_draft/:id", :controller => "drafts", :action => "destroy"
  #------------------------------

  # Routes for the League resource:
  # CREATE
  get "/leagues/new", :controller => "leagues", :action => "new"
  post "/create_league", :controller => "leagues", :action => "create"

  # READ
  get "/leagues", :controller => "leagues", :action => "index"
  get "/leagues/:id", :controller => "leagues", :action => "show"

  # DELETE
  get "/delete_league/:id", :controller => "leagues", :action => "destroy"
  
  
  get "/leagues/:id/draft", :controller => "leagues", :action => "draft"
  
  
  #------------------------------


  # READ
  get "/players", :controller => "players", :action => "index"
  get "/players/:id", :controller => "players", :action => "show"

  devise_for :users
  # Routes for the User resource:
  # READ
  get "/users", :controller => "users", :action => "index"
  get "/users/:id", :controller => "users", :action => "show"


  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
