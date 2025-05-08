# app/controllers/posts_controller.rb
class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:index, :show, :tag]
  before_action :check_post_owner, only: [:edit, :update, :destroy]
  
  def index
    @posts = Post.published.includes(:user, :rich_text_content, :taggings)
    
    if params[:search].present?
      @posts = @posts.search(params[:search])
    end
    
    @posts = @posts.page(params[:page]).per(10) if @posts.respond_to?(:page)
  end
  
  def show
    # If post is premium and user is not logged in or not the author
    if @post.premium? && (!user_signed_in? || current_user != @post.user)
      flash[:alert] = "This post is for premium users only"
      redirect_to posts_path
    end
  end
  
  def new
    @post = current_user.posts.build
  end
  
  def create
    @post = current_user.posts.build(post_params)
    
    if @post.save
      redirect_to @post, notice: 'Post was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end
  
  def edit
  end
  
  def update
    if @post.update(post_params)
      redirect_to @post, notice: 'Post was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end
  
  def destroy
    @post.destroy
    redirect_to posts_path, notice: 'Post was successfully deleted.'
  end
  
  def tag
    @tag = ActsAsTaggableOn::Tag.find_by!(name: params[:tag])
    @posts = Post.published.tagged_with(@tag.name).includes(:user, :rich_text_content)
    @posts = @posts.page(params[:page]).per(10) if @posts.respond_to?(:page)
    
    render :index
  end
  
  private
  
  def set_post
    @post = Post.find_by_param(params[:id])
    redirect_to posts_path, alert: "Post not found" unless @post
  end
  
  def post_params
    params.require(:post).permit(:title, :content, :description, :published, :premium, :tag_list)
  end
  
  def check_post_owner
    unless current_user == @post.user
      redirect_to posts_path, alert: "You don't have permission to do that."
    end
  end
end