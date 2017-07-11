class MicropostsController < ApplicationController
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
        @micropost = current_user_api(request.headers[:HTTP_AUTHORIZATION]).microposts.build(micropost_params)
        if @micropost.save
          render json: {message: "Micropost created!"} 
        else
          render json: {message: "Micropost creation was failed"}, status: 400 
        end
      }
    end
  end

  def destroy
    respond_to do |format|
      @micropost.destroy
      fotmat.html{
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

  def correct_user
    @micropost = current_user.microposts.find_by(id: params[:id])
    redirect_to root_url if @micropost.nil?
  end

end
