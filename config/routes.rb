Rails.application.routes.draw do
  # Routes for the Player resource:
  # CREATE
  get "/players/new", :controller => "players", :action => "new"
  post "/create_player", :controller => "players", :action => "create"

  # READ
  get "/players", :controller => "players", :action => "index"
  get "/players/:id", :controller => "players", :action => "show"

  # UPDATE
  get "/players/:id/edit", :controller => "players", :action => "edit"
  post "/update_player/:id", :controller => "players", :action => "update"

  # DELETE
  get "/delete_player/:id", :controller => "players", :action => "destroy"
  #------------------------------

  devise_for :users
  # Routes for the User resource:
  # READ
  get "/users", :controller => "users", :action => "index"
  get "/users/:id", :controller => "users", :action => "show"


  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
