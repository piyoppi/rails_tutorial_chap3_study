class MicropostsController < ApplicationController
  protect_from_forgery with: :null_session
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user, only: :destroy

  def create
    respond_to do |format|
      format.html {
        @micropost = current_user.microposts.build(micropost_params)
        if @micropost.save
          flash[:success] = "Micropost created!"
          redirect_to root_url
        else
          @feed_items = []
          render 'static_pages/home'
        end
      }
      format.json{
        @micropost = current_user_api.microposts.build(micropost_params_api)
        if @micropost.save
          render json: {message: "Micropost created!", id: @micropost.reload.id} 
        else
          render json: {message: "Micropost creation was failed"}, status: 400 
        end
      }
    end
  end

  def destroy
    @micropost.destroy
    respond_to do |format|
      format.html{
        flash[:success] = "Micropost deleted"
        redirect_back(fallback_location: root_url)
      }
      format.json{
        render json: {message: "Micropost deleted"} 
      }
    end
  end

  private

  def micropost_params
    params.require(:micropost).permit(:content, :picture)
  end

  def micropost_params_api
    params.permit(:content, :picture)
  end

  def correct_user
    respond_to do |format|
      format.html { @micropost = current_user.microposts.find_by(id: params[:id]) }
      format.json { @micropost = current_user_api.microposts.find_by(id: params[:id]) }
    end
   
    redirect_to root_url if @micropost.nil?
  end

end
