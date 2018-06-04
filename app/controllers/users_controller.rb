class UsersController < ApplicationController
  def index
    @users = User.page(params[:page]).per(10)
  end

  def show
    @user = User.find(params[:id])
  end
  
  def home
    render("layouts/homepage.html.erb")
  end
end
