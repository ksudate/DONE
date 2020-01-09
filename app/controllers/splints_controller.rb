require 'net/http'
require 'json'

class SplintsController < ApplicationController
  include Common
  protect_from_forgery except: [:delete_splint]
  before_action :line_login, only: [:index]
  before_action :authenticate_user
  before_action :ensure_correct_user_splint, only: %i[edit update destroy]

  def index
    require_accesstoken
    @splint = Splint.where(user_id: session[:user_id])
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

  def delete_splint
    @splint = Splint.where(sp_number: params[:sp_number])
    @splint.destroy_all
    redirect_to splints_path
  end

  def analysis
    @splint_keep = Splint.where(user_id: session[:user_id]).where(kpt: 'Keep')
    @splint_problem = Splint.where(user_id: session[:user_id]).where(kpt: 'Problem')
    @splint_try = Splint.where(user_id: session[:user_id]).where(kpt: 'Try')
  end

  private

  def splint_params
    params.require(:splint).permit(:content, :kpt, :sp_number, :user_id)
  end

  def splint_edit_params
    params.require(:splint).permit(:content)
  end
end
