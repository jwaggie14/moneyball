class DraftsController < ApplicationController
  def index
    @q = Draft.ransack(params[:q])
    @drafts = @q.result(:distinct => true).includes(:players, :league).page(params[:page]).per(10)

    render("drafts/index.html.erb")
  end

  def show
    @draft = Draft.find(params[:id])

    render("drafts/show.html.erb")
  end

  def new
    @draft = Draft.new

    render("drafts/new.html.erb")
  end

  def create
    @draft = Draft.new

    @draft.draft_id = params[:draft_id]
    @draft.players_id = params[:players_id]
    @draft.pick_num = params[:pick_num]
    @draft.team = params[:team]

    save_status = @draft.save

    if save_status == true
      referer = URI(request.referer).path

      case referer
      when "/drafts/new", "/create_draft"
        redirect_to("/drafts")
      else
        redirect_back(:fallback_location => "/")
      end
    else
      render("drafts/new.html.erb")
    end
  end

  def edit
    @draft = Draft.find(params[:id])

    render("drafts/edit.html.erb")
  end

  def update
    @draft = Draft.find(params[:id])

    @draft.draft_id = params[:draft_id]
    @draft.players_id = params[:players_id]
    @draft.pick_num = params[:pick_num]

    save_status = @draft.save

    if save_status == true
      referer = URI(request.referer).path

      case referer
      when "/drafts/#{@draft.id}/edit", "/update_draft"
        redirect_to("/drafts/#{@draft.id}", :notice => "Draft updated successfully.")
      else
        redirect_back(:fallback_location => "/", :notice => "Draft updated successfully.")
      end
    else
      render("drafts/edit.html.erb")
    end
  end

  def destroy
    @draft = Draft.find(params[:id])

    @draft.destroy

    if URI(request.referer).path == "/drafts/#{@draft.id}"
      redirect_to("/", :notice => "Draft deleted.")
    else
      redirect_back(:fallback_location => "/",)
    end
  end
end
