class Admin::CategoriesController < ApplicationController
  before_action :logged_in_user
  before_action :verify_admin
  before_action :find_category, except: [:index, :new, :create]

  def index
    @categories = Category.paginate page: params[:page],
      per_page: Settings.per_page_categories
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new category_params
    if @category.save
      flash[:success] = t "flash.category_created"
      redirect_to admin_categories_path
    end
  end

  def destroy
    if @category.destroy
      flash[:success] = t "flash.create_category_success"
    else
      flash[:danger] = t "flash.delete_category_fail"
    end
    redirect_to admin_categories_path
  end

  def show
    @words = @category.words .paginate page: params[:page],
      per_page: Settings.per_page_words
  end

  def edit
  end

  def update
    if @category.update_attributes category_params
      flash[:success] = t "flash.category_updated_success"
      redirect_to admin_categories_path
    else
      render :edit
    end
  end

  private
  def find_category
    @category= Category.find_by id: params[:id]
    unless @category
      flash[:danger] = t "flash.find_category_fail"
      redirect_to root_path
    end
  end

  def category_params
    params.require(:category).permit :name
  end
end
