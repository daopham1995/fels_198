class UsersController < ApplicationController
  before_action :logged_in_user, except: [:create, :new]
  before_action :find_user, except: [:index, :new, :create]
  before_action :valid_user, only: [:edit, :update]

  def show
    @lessons = current_user.lessons.paginate page: params[:page],
      per_page: Settings.users_show_lessons
    @relationship = if current_user.following? @user
      current_user.active_relationships.find_by followed_id: @user.id
    else
      current_user.active_relationships.build
    end
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      log_in @user
      flash[:success] = t "flash.login_success"
      redirect_back_or @user
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @user.update_attributes user_params
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render "edit"
    end
  end

  private
  def find_user
    @user= User.find_by id: params[:id]
    unless @user
      flash[:danger] = t "flash.find_user_fail"
      redirect_to root_path
    end
  end

  def user_params
    params.require(:user).permit :name, :email, :password, :avatar,
      :password_confirmation 
  end

  def valid_user
    redirect_to root_url unless @user == current_user
  end
end
