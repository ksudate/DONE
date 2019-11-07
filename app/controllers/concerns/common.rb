module Common
  extend ActiveSupport::Concern

  def setup
    @client_id = Rails.application.credentials.line[:client_id]
    @client_secret = Rails.application.credentials.line[:client_secret]
  end

  def fetch_token(code)
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
    hash['access_token']
  end

  def fetch_line_profile
    uri = URI.parse('https://api.line.me/v2/profile')
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = uri.scheme === 'https'
    headers = { 'Authorization' => "Bearer #{session[:access_token]}" }
    response = http.get(uri.path, headers)
    hash = JSON.parse(response.body)
    hash['userId']
  end

  def revoke_token
    uri = URI.parse('https://api.line.me/oauth2/v2.1/revoke')
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = uri.scheme === 'https'
    headers = { 'Content-Type' => 'application/x-www-form-urlencoded' }
    params = {
      access_token: session[:access_token],
      client_id: @client_id,
      client_secret: @client_secret
    }
    req = Net::HTTP::Post.new(uri.path)
    req.set_form_data(params)
    req.initialize_http_header(headers)
    response = http.request(req)
    return if response.to_s.include?('Net::HTTPOK')

    flash.now[:danger] = '処理に失敗しました。再度、ログイン・ログアウトをおこなってください'
  end

  def line_login
    return if session[:line_id]

    setup
    code = params[:code]
    access_token = fetch_token(code)
    session[:access_token] = access_token
    line_id = fetch_line_profile
    session[:line_id] = line_id
  end

  def line_logout
    setup
    revoke_token
    session.delete(:access_token)
    session.delete(:line_id)
  end
end
