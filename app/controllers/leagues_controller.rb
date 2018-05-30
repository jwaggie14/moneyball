class LeaguesController < ApplicationController
  before_action :current_user_must_be_league_user, :only => [:edit, :update, :destroy]

  def current_user_must_be_league_user
    league = League.find(params[:id])

    unless current_user == league.user
      redirect_to :back, :alert => "You are not authorized for that."
    end
  end

  def index
    @leagues = current_user.leagues.page(params[:page]).per(10)

    render("leagues/index.html.erb")
  end

  def show
    @league = League.find(params[:id])

    render("leagues/show.html.erb")
  end

  def new
    @league = League.new

    render("leagues/new.html.erb")
  end

  def create
    @league = League.new

    @league.user_id = params[:user_id]
    @league.num_teams = params[:num_teams]
    @league.scoring = params[:scoring]
    @league.user_first_pick = params[:user_first_pick]
    @league.league_name = params[:league_name]

    save_status = @league.save

    if save_status == true
      referer = URI(request.referer).path

      case referer
      when "/leagues/new", "/create_league"
        redirect_to("/leagues")
      else
        redirect_back(:fallback_location => "/", :notice => "League created successfully.")
      end
    else
      render("leagues/new.html.erb")
    end
  end

  def edit
    @league = League.find(params[:id])

    render("leagues/edit.html.erb")
  end

  def update
    @league = League.find(params[:id])
    @league.num_teams = params[:num_teams]
    @league.scoring = params[:scoring]
    @league.user_first_pick = params[:user_first_pick]
    @league.league_name = params[:league_name]

    save_status = @league.save

    if save_status == true
      referer = URI(request.referer).path

      case referer
      when "/leagues/#{@league.id}/edit", "/update_league"
        redirect_to("/leagues/#{@league.id}", :notice => "League updated successfully.")
      else
        redirect_back(:fallback_location => "/", :notice => "League updated successfully.")
      end
    else
      render("leagues/edit.html.erb")
    end
  end

  def destroy
    @league = League.find(params[:id])

    @league.destroy

    if URI(request.referer).path == "/leagues/#{@league.id}"
      redirect_to("/", :notice => "League deleted.")
    else
      redirect_back(:fallback_location => "/", :notice => "League deleted.")
    end
  end
end
