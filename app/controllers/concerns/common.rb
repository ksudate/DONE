module Common
  extend ActiveSupport::Concern

  def setup
    @client_id = Rails.application.credentials.line[:client_id]
    @client_secret = Rails.application.credentials.line[:client_secret]
  end

  def line_login
    setup
    code = params[:code]
    uri = URI.parse('https://api.line.me/oauth2/v2.1/token')
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = uri.scheme === 'https'
    headers = { 'Content-Type' => 'application/x-www-form-urlencoded' }
    params = {
      grant_type: 'authorization_code',
      code: code,
      # redirect_uri: 'http://localhost:3000/posts',
      redirect_uri: 'https://tmrekk121-done.herokuapp.com/posts',
      client_id: @client_id,
      client_secret: @client_secret
    }
    req = Net::HTTP::Post.new(uri.path)
    req.set_form_data(params)
    req.initialize_http_header(headers)
    response = http.request(req)
    hash = JSON.parse(response.body)
    access_token = hash['access_token']
    if session[:access_token].nil? || session[:access_token] != access_token
      session[:access_token] = access_token
    end
    uri = URI.parse('https://api.line.me/v2/profile')
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = uri.scheme === 'https'
    headers = { 'Authorization' => "Bearer #{session[:access_token]}" }
    response = http.get(uri.path, headers)
    hash = JSON.parse(response.body)
    line_id = hash['userId']
    if session[:line_id].nil? || session[:line_id] != line_id
      session[:line_id] = line_id
    end
  end
end
