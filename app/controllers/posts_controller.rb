require 'net/http'
require 'json'

class PostsController < ApplicationController
  include Common
  before_action :line_login, only: [:index]
  before_action :authenticate_user
  before_action :ensure_correct_user_post, only: %i[edit update destroy]

  def index
    require_accesstoken
    @post = Post.where(line_id: session[:line_id])
  end

  def show
    @post = Post.find(params[:id])
  end

  def new
    @post = Post.new
    @user = User.find_by(line_id: session[:line_id])
  end

  def edit
    @post = Post.find(params[:id])
  end

  def create
    @post = Post.new(post_params)
    @post.save
    redirect_to posts_path
  end

  def update
    post = Post.find(params[:id])
    post.update(post_params)
    redirect_to posts_path
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to posts_path
  end

  private

  def post_params
    params.require(:post).permit(:content, :line_id, :rank, :deadline, :user_id)
  end
end
