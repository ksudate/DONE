class LineBotController < ApplicationController
  require 'line/bot'
  protect_from_forgery :except => [:callback]

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
    events = client.parse_events_from(body)
    events.each do |event|
      user_id = event['source']['userId']
      # request_message = event['message']['text']
      response = '今日のタスクは' + "\n"
      post = Post.where(line_id: user_id)
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
end
