class MembersController < ApplicationController
  def create
    new_member = User.find(session[:user_id])
    member = new_member.members.build(room_id: params[:room_id])
    member.save
    redirect_to rooms_path
  end

  def destroy; end
end
