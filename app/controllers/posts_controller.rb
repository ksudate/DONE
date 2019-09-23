require 'net/http'
require 'json'

class PostsController < ApplicationController
  include Common
  before_action :line_login, only: [:show]

  def show
    fetch_lineid
  end

  def new
    
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
end
