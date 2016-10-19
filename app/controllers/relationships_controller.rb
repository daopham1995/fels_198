class RelationshipsController < ApplicationController
  before_action :logged_in_user

  def index
    @user = User.find_by id: params[:user_id]
    if @user.nil?
      flash[:danger] = t :user_fails
      redirect_to root_path
    else
      relationship = params[:relationship]
      @title = relationship
      @users = @user.send(relationship).paginate page: params[:page]
    end
  end
end
