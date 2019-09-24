require 'net/http'
require 'json'

class PostsController < ApplicationController
  include Common
  before_action :line_login, only: [:index]
  before_action :fetch_lineid, only: [:index, :new, :edit]

  def index
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
      fetch_lineid
      Post.create(post_params)
      redirect_to '/posts'
    end
  end

  def update
    Post.update(post_params)
    redirect_to '/posts'
  end

  def destroy
    post = Post.find(params[:id])
    post.destroy
    redirect_to '/posts'
  end

  private

  def fetch_lineid
    uri = URI.parse('https://api.line.me/v2/profile')
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = uri.scheme === 'https'
    headers = { 'Authorization' => "Bearer #{session[:access_token]}" }
    response = http.get(uri.path, headers)
    hash = JSON.parse(response.body)
    @line_id = hash['userId']
  end

  def post_params
    params.require(:post).permit(:content, :line_id)
  end
end