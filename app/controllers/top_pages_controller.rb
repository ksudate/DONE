require 'net/http'
require 'json'

class TopPagesController < ApplicationController
  before_action :setup, only: [:home, :line_login]

  def home
    @url = 'https://access.line.me/oauth2/v2.1/authorize?response_type=code&client_id=' + @client_id.to_s + '&redirect_uri=http%3a%2f%2flocalhost%3a3000%2ftop_pages%2fline_login&state=12345abcde&scope=openid%20profile'
  end

  def line_login
    code = params[:code]
    uri = URI.parse('https://api.line.me/oauth2/v2.1/token')
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = uri.scheme === 'https'
    headers = { 'Content-Type' => 'application/x-www-form-urlencoded' }
    params = {
      grant_type: 'authorization_code',
      code: code,
      redirect_uri: 'http://localhost:3000/top_pages/line_login',
      client_id: @client_id,
      client_secret: @client_secret
    }
    req = Net::HTTP::Post.new(uri.path)
    req.set_form_data(params)
    req.initialize_http_header(headers)
    @response = http.request(req)
    hash = JSON.parse(@response.body)
    @access_token = hash['access_token']
  end

  private

  def setup
    @client_id = Rails.application.credentials.line[:client_id]
    @client_secret = Rails.application.credentials.line[:client_secret]
  end
end
