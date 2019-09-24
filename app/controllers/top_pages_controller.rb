class TopPagesController < ApplicationController
  include Common
  before_action :setup, only: [:home]

  def home
    # @url = 'https://access.line.me/oauth2/v2.1/authorize?response_type=code&client_id=' + @client_id.to_s + '&redirect_uri=http%3a%2f%2flocalhost%3a3000%2fposts&state=12345abcde&bot_prompt=aggressive&scope=openid%20profile'
    @url = 'https://access.line.me/oauth2/v2.1/authorize?response_type=code&client_id=' + @client_id.to_s + '&redirect_uri=https%3a%2f%2ftmrekk121%2ddone%2eherokuapp%2ecom%2fposts&scope=openid%20profile'
  end
end
