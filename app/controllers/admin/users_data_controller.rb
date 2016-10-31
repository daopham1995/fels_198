class Admin::UsersDataController < ApplicationController
  before_action :logged_in_user
  before_action :verify_admin
  
  def index
    @users = User.order :name
    respond_to do |format|
      format.html
      format.csv {render text: @users.to_csv}
      format.xls
    end
  end
end
