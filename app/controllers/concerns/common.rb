module Common
  extend ActiveSupport::Concern

  def setup
    @client_id = Rails.application.credentials.line[:client_id]
    @client_secret = Rails.application.credentials.line[:client_secret]
  end

  def ensure_correct_user_post
    @post = Post.find(params[:id])
    return if @post.line_id == session[:line_id]

    flash[:notice] = '権限がありません'
    redirect_to posts_path
  end

  def ensure_correct_user_splint
    @splint = Splint.find(params[:id])
    return if @post.line_id == session[:line_id]

    flash[:notice] = '権限がありません'
    redirect_to posts_path
  end

  def authenticate_user
    return if session[:line_id]

    flash[:notice] = 'ログインしてください'
    redirect_to root_path
  end

  def require_accesstoken
    @user = User.find_by(line_id: session[:line_id])
    @access_token = @user.access_token
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

  def fetch_line_profile(access_token)
    uri = URI.parse('https://api.line.me/v2/profile')
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = uri.scheme === 'https'
    headers = { 'Authorization' => "Bearer #{access_token}" }
    response = http.get(uri.path, headers)
    hash = JSON.parse(response.body)
    hash['userId']
  end

  def revoke_token
    require_accesstoken
    uri = URI.parse('https://api.line.me/oauth2/v2.1/revoke')
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = uri.scheme === 'https'
    headers = { 'Content-Type' => 'application/x-www-form-urlencoded' }
    params = {
      access_token: @access_token,
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

  def create_usertable(access_token, line_id)
    User.create(line_id: line_id, access_token: access_token) unless User.find_by(line_id: line_id)
  end

  def line_login
    return if session[:line_id]

    setup
    code = params[:code]
    access_token = fetch_token(code)
    line_id = fetch_line_profile(access_token)
    session[:line_id] = line_id
    create_usertable(access_token, line_id)
    flash[:notice] = 'ログインしました'
  end

  def line_logout
    setup
    revoke_token
    session.delete(:line_id)
    flash[:notice] = 'ログアウトしました'
    redirect_to root_path
  end
end
