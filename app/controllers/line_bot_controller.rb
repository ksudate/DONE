class LineBotController < ApplicationController
  require 'line/bot'
  protect_from_forgery :except => [:callback]
  before_action :fetch_lineid, only: [:callback]

  def client
    @client ||= Line::Bot::Client.new { |config|
      config.channel_id = Rails.application.credentials.bot[:channel_id]
      config.channel_secret = Rails.application.credentials.bot[:channel_secret]
      config.channel_token = Rails.application.credentials.bot[:channel_token]
    }
  end

  def callback
    body = request.body.read
    signature = request.env['HTTP_X_LINE_SIGNATURE']
    unless client.validate_signature(body, signature)
      head :bad_request
    end
    # lineのidに基づいた投稿を取得
    events = client.parse_events_from(body)
    events.each do |event|
      logger.debug('-----')
      logger.debug(event)
      logger.debug(event.source)
      logger.debug(event.message)
      logger.debug('------')
      response = '今日のタスクは' + "\n"
      post = Post.where(line_id: event.source['userId'])
      logger.debug(post)
      post.each do |p|
        response += p.content + "\n"
      end
      case event
      when Line::Bot::Event::Message
        case event.type
        when Line::Bot::Event::MessageType::Text
          message = {
            type: 'text',
            text: response
          }
          client.reply_message(event['replyToken'], message)
        end
      end
    end

    head :ok
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
