class Admin::UsersController < ApplicationController
  before_action :logged_in_user
  before_action :verify_admin
  before_action :find_user, only: [:show, :destroy]

  def index
    @users = if params[:name].present?
      User.find_by_username params[:name]
    else
      User.all
    end
    @users = @users.paginate page: params[:page],
      per_page: Settings.per_page_users
    respond_to do |format|
      format.html
      format.js
    end
  end

  def show
  end

  def destroy
    if @user.destroy
      flash[:success] = t "flash.delete_user_success"
    else
      flash[:danger] = t "flash.delete_user_fail"
    end
    redirect_to admin_users_path
  end

  private
  def find_user
    @user= User.find_by id: params[:id]
    unless @user
      flash[:danger] = t "flash.find_user_fail"
      redirect_to root_path
    end
  end
end
