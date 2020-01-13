class MembersController < ApplicationController
  def create
    # current_user = User.find(session[:user_id])
    member = current_user.members.build(room_id: params[:room_id])
    member.save
    redirect_to rooms_path
  end

  def destroy
  end
end
