class Admin::WordsController < ApplicationController
  before_action :logged_in_user
  before_action :verify_admin
  before_action :find_word, except: [:index, :new, :create]

  def index
    @words = if params[:option].present?
      Word.filter_by_category(params[:category_id])
        .filter_by_level(params[:levels]).send(params[:option], current_user)
    else
      Word.all
    end
    @words = @words.paginate page: params[:page],
      per_page: Settings.per_page_words
    @view_word = Supports::Word.new @words.first
  end

  def new
    @word = Word.new
    @view_word = Supports::Word.new @word
    Settings.number_of_answer.times {@word.answers.build}
    @category_id = params[:category_id]
  end

  def create
    @word = Word.new word_params
    if @word.save
      flash[:success] = t "flash.word_created_success"
      redirect_to admin_words_path
    else
      @view_word = Supports::Word.new @word
      render :new
    end
  end

  def edit
    @view_word = Supports::Word.new @word
  end

  def update
    if @word.update_attributes word_params
      flash[:success] = t "flash.word_updated_success"
      redirect_to admin_words_path
    else
      @view_word = Supports::Word.new @word
      render :edit
    end
  end

  def destroy
    if @word.destroy
      flash[:success] = t "flash.delete_word_success"
    else
      flash[:danger] = t "flash.delete_word_fail"
    end
    redirect_to admin_words_path
  end

  private
  def find_word
    @word= Word.find_by id: params[:id]
    unless @word
      flash[:danger] = t "flash.find_word_fail"
      redirect_to root_path
    end
  end

  def word_params
    params.require(:word).permit :category_id, :question, :levels,
      answers_attributes: [:id, :content, :is_correct, :_destroy]
  end
end
