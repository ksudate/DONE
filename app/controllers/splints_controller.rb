require 'net/http'
require 'json'

class SplintsController < ApplicationController
  include Common
  before_action :line_login, only: [:index]

  def index
    @splint = Splint.where(line_id: session[:line_id])
  end

  def show
    @splint = Splint.find(params[:id])
  end

  def new
    @splint = Splint.new
    @sp_number = params[:sp_number]
  end

  def edit
    @splint = Splint.find(params[:id])
  end

  def create
    if session[:access_token].nil?
      render action: :index
      flash.now[:danger] = 'ログインしてください。'
    else
      Splint.create(splint_params)
      redirect_to splints_path
    end
  end

  def update
    splint = Splint.find(params[:id])
    splint.update(splint_edit_params)
    redirect_to splints_path
  end

  def destroy
    @splint = Splint.find(params[:id])
    @splint.destroy
    redirect_to splints_path
  end

  private

  def splint_params
    params.require(:splint).permit(:content, :line_id, :kpt, :sp_number)
  end

  def splint_edit_params
    params.require(:splint).permit(:content, :line_id)
  end
end
