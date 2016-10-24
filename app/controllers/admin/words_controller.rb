class Admin::WordsController < ApplicationController
  before_action :logged_in_user
  before_action :verify_admin

  def index
    @words = Word.paginate page: params[:page],
      per_page: Settings.per_page_words
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
      answers_attributes: [:content, :is_correct, :_destroy]
  end
end
