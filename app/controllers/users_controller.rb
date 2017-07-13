class UsersController < ApplicationController
  rescue_from Api::Errors::Base, with: :handle_error
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy, :following, :followers]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy

  GET_USER_UNIT = 10
  GET_MICROPOST_UNIT = 10
  GET_FOLLOWING_UNIT = 10
  GET_FOLLOWERS_UNIT = 10

  def index
    respond_to do |format|
      format.html { @users = User.where(activated: true).paginate(page: params[:page]) }
      format.json { render json: {users: User.select("id,name").where(activated: true).limit(GET_USER_UNIT).offset(GET_USER_UNIT * params[:page].to_i)}, status: 200 }
    end
  end

  def show
    @user = User.find(params[:id])
    respond_to do |format|
      format.html {
        @microposts = @user.microposts.paginate(page: params[:page])
        redirect_to root_url and return unless @user.activated
      }
      format.json {
        render json: {micropost: @user.microposts.limit(GET_MICROPOST_UNIT).offset(GET_MICROPOST_UNIT * params[:page].to_i), status: 200 }
      }
    end
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:info] = "Please check your email to activate your account"
      redirect_to root_url
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end

  def following
    @user = User.find(params[:id])
    respond_to do |format|
      format.html{
        @title = "Following"
        @users = @user.following.paginate(page: params[:page])
        render 'show_follow'
      }
      format.json{
        render json: { users: @user.following.limit(GET_FOLLOWING_UNIT).offset(GET_FOLLOWING_UNIT * params[:page].to_i), status: 200 }       
      }
    end
  end

  def followers
    @user = User.find(params[:id])
    respond_to do |format|
      format.html{
        @title = "Followers"
        @users = @user.followers.paginate(page: params[:page])
        render 'show_follow'
      }
      format.json{
        render json: { users: @user.followers.limit(GET_FOLLOWERS_UNIT).offset(GET_FOLLOWERS_UNIT * params[:page].to_i), status: 200 }       
      }
    end
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation )
    end

    def user_content
      params.require(:user).permit(:id, :name)
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end

    def handle_error(error)
      render json: {message: error.detail}, status: error.status_code
    end

end
