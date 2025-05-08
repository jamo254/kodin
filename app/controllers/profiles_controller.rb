class ProfilesController < ApplicationController
  before_action :set_user, only: [:show]
  before_action :authenticate_user!, only: [:edit, :update]
  
  def show
    @posts = @user.posts.published.page(params[:page]).per(10)
  end
  
  def edit
    @user = current_user
  end
  
  def update
    @user = current_user
    
    if @user.update(user_params)
      redirect_to profile_path(@user.username), notice: 'Profile was successfully updated.'
    else
      render :edit
    end
  end
  
  private
  
  def set_user
    @user = User.find_by!(username: params[:username])
  end
  
  def user_params
    params.require(:user).permit(:username, :first_name, :last_name, :bio, 
                                :github_url, :twitter_url, :website_url, :avatar)
  end
end