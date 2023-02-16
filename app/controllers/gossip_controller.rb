class GossipController < ApplicationController
  before_action :require_login, only: [:new, :create]
  before_action :authorize_user, only: [:edit, :update, :destroy]

  def index
      @gossip = Gossip.all
  end
  
  def show
      @gossip = Gossip.find(params[:id])
  end


  def new
      @gossip = Gossip.new
  end
  
  def create
      @gossip = current_user.gossips.build(title: params[:title], content: params[:content])
      if @gossip.save
        flash[:success] = "Potin bien créé !"
        redirect_to root_path
      else
        render 'new'
      end
    end 

  def edit
      @gossip = Gossip.find(params[:id])
  end
  
  def update
      @gossip = Gossip.find(params[:id])
      post_params = params.require(:gossip).permit(:title, :content)
      @gossip.update(post_params)
      redirect_to gossip_path
  end

  def destroy
      @gossip = Gossip.find(params[:id])
      @gossip.destroy
      redirect_to root_path
  end

  private

  def require_login
    unless current_user
        flash[:error] = "Vous devez être connecté"
        redirect_to new_session_path
    end
end

private

def authorize_user
  @gossip = Gossip.find(params[:id])
  unless @gossip.user == current_user
    flash[:error] = "Vous n'êtes pas autorisé à modifier ou supprimer ce potin."
    redirect_to root_path
  end
end

end