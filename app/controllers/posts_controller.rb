require 'net/http'
require 'json'

class PostsController < ApplicationController
  include Common
  before_action :line_login, only: [:index]
  protect_from_forgery :except => [:index]

  def index
    logger.debug(@line_id)
    @post = Post.where(line_id: @line_id)
  end

  def show
    @post = Post.find(params[:id])
  end

  def new
    @post = Post.new
  end

  def edit
    @post = Post.find(params[:id])
  end

  def create
    if session[:access_token].nil?
      render template: 'top_pages/home'
      flash.now[:danger] = 'ログインしてください。'
    else
      Post.create(post_params)
      redirect_to posts_path
    end
  end

  def update
    post = Post.find(params[:id])
    post.update(post_params)
    redirect_to '/posts'
  end

  def destroy
    post = Post.find(params[:id])
    post.destroy
    redirect_to '/posts'
  end

  private

  def post_params
    params.require(:post).permit(:content, :line_id)
  end
end
