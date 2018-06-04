class LeaguesController < ApplicationController
  before_action :current_user_must_be_league_user, :only => [:show, :edit, :update, :destroy]

  def current_user_must_be_league_user
    league = League.find(params[:id])

    unless current_user == league.user
      redirect_to :back, :alert => "You are not authorized for that."
    end
  end

  def index
    @q = current_user.leagues.ransack(params[:q])
    @leagues = @q.result(:distinct => true).includes(:user, :drafts, :players).page(params[:page]).per(20)

    render("leagues/index.html.erb")
  end

  def show
    @draft = Draft.new
    @league = League.find(params[:id])
    @drafts = Draft.where(draft_id: @league.id.to_s)
    @num_teams = @league.num_teams
    @my_pick = @league.user_first_pick
    
    @team_points = []
    @team_adp = []
    (1..@num_teams).each do |team_num|
      tp = 0
      ad = 0
      x = Draft.where('draft_id = ? AND team = ?', @league.id, team_num)
      x.each do |plr|
        pl = Player.find(plr.players_id)
        tp += pl.points
        ad += pl.adp
      end
      tp = tp/17.0
      if x > 0
        ad = ad / x.count
      else
        ad = ""
      end
      @team_points.push(tp)
      @team_adp.push(ad)
    end
    @team_ranks = @team_points.each_index.max_by(@num_teams){|i| @team_points[i]}


    render("leagues/show.html.erb")
  end

def team_given_pick(pick_num, league_size)
  round = ((pick_num - 1).div league_size) + 1
  pick = ((pick_num - 1) % league_size) + 1
  if round % 2 == 0
    team = league_size - pick + 1
  else
    team = pick
  end
  return team
end

  def draft
    @draft = Draft.new
    @league = League.find(params[:id])
    @current_pick = Draft.where(draft_id: @league.id.to_s).maximum("pick_num")
    @current_pick_draft_num = Draft.where(draft_id: @league.id.to_s).maximum("id")
    @current_pick = @current_pick.nil? ? 0 : @current_pick
    @ps = Player.where.not(id: Draft.where(draft_id: @league.id.to_s).pluck(:players_id))
    @rbs = @ps.where(position: "rb").to_a.map(&:serializable_hash).sort_by { |k| k["vor"] }.reverse
    @qbs = @ps.where(position: "qb").to_a.map(&:serializable_hash).sort_by { |k| k["vor"] }.reverse
    @wrs = @ps.where(position: "wr").to_a.map(&:serializable_hash).sort_by { |k| k["vor"] }.reverse
    @tes = @ps.where(position: "te").to_a.map(&:serializable_hash).sort_by { |k| k["vor"] }.reverse
    @ks = @ps.where(position: "k").to_a.map(&:serializable_hash).sort_by { |k| k["vor"] }.reverse
    @dst = @ps.where(position: "dst").to_a.map(&:serializable_hash).sort_by { |k| k["vor"] }.reverse
    @num_teams = @league.num_teams
    @my_pick = @league.user_first_pick
    @team_pick = team_given_pick((@current_pick + 1), @num_teams)
    @count_my_picks = Draft.where('draft_id = ? AND team = ?', @league.id, @my_pick)
    @best_p = @ps.first
    @best_p2 = @ps.offset(1).first
    @best_p3 = @ps.offset(2).first
    
    @r_t = ((@current_pick).div @num_teams) + 1
    @p_t = ((@current_pick) % @num_teams) + 1
    
    trp = @r_t % 2 == 0 ? (@r_t * @num_teams.to_i - @my_pick.to_i + 1) : ((@r_t - 1) * @num_teams.to_i + @my_pick.to_i)
    r2 = @r_t + 1
    nrp = r2 % 2 == 0 ? (r2 * @num_teams.to_i - @my_pick.to_i + 1) : ((r2 - 1) * @num_teams.to_i + @my_pick.to_i)
    your_next_pick = ((@current_pick + 1) >= trp) ? nrp : trp
    @cd_to_mp = your_next_pick - (@current_pick + 1)
    @available_players = [@rbs, @qbs, @wrs, @tes, @ks, @dst]
    @available_players.each do |rray|
      z = -1
      rray.each do |hsh|
        z += 1
        z = (z == rray.count - 1) ? z-1 : z
        next_best = rray[z + 1]["points"]
        hsh["opp_cost"] = hsh["points"] - next_best
        hsh["adp"] = (hsh["adp"] == 0.0 ) ? 200 : hsh["adp"]
        hsh['pick_prob'] = (((your_next_pick - hsh["adp"])*1.0/30.0 + 0.5))
        hsh['pick_prob'] = [hsh['pick_prob'],0.0,1.0].sort[1]
        hsh["opp_cost"] = hsh["opp_cost"] * hsh['pick_prob']
      end
      cost = 0
      rray.reverse.each do |hsh|
        cost += hsh["opp_cost"]
        hsh["cumulative_oc"] = cost
      end
    end
    best_p = []
    @available_players.each do |rray|
      best_p.push(rray[0])
    end
    
    best_p = best_p.sort_by { |k| k["cumulative_oc"] }.reverse
    @best_p =  best_p[0]
    @best_p2 = best_p[1]
    @best_p3 = best_p[2]
    render("leagues/draft.html.erb")
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
