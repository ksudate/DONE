require 'net/http'
require 'json'

class SplintsController < ApplicationController
  include Common
  protect_from_forgery :except => [:destroy_splint]
  before_action :line_login, only: [:index]
  before_action :authenticate_user
  before_action :ensure_correct_user_splint, only: %i[edit update destroy]

  def index
    require_accesstoken
    @splint = Splint.where(line_id: session[:line_id])
  end

  def show
    @splint = Splint.find(params[:id])
  end

  def new
    @splint = Splint.new
    @sp_number = params[:sp_number]
    @user = User.find_by(line_id: session[:line_id])
  end

  def edit
    @splint = Splint.find(params[:id])
  end

  def create
    Splint.create(splint_params)
    redirect_to splints_path
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

  def destroy_splint
    @splint = Splint.where(sp_number: params[:sp_number])
    @splint.destroy_all
    redirect_to splints_path
  end

  def analysis
    
  end

  private

  def splint_params
    params.require(:splint).permit(:content, :line_id, :kpt, :sp_number, :user_id)
  end

  def splint_edit_params
    params.require(:splint).permit(:content, :line_id)
  end
end
