class RoomsController < ApplicationController
  def index
    @rooms = Room.all
  end

  def show
    @room = Room.find(params[:id])
  end

  def new
    @room = Room.new
  end

  def create
    @room = Room.new(room_params)
    if @room.save
      redirect_to rooms_path
    else
      render rooms_path
    end
  end

  private

  def room_params
    params.require(:room).permit(:name, :admin_user_id)
  end
end
