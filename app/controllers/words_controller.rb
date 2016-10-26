class WordsController < ApplicationController
  before_action :logged_in_user

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
    respond_to do |format|
      format.html
      format.js
    end
  end
end
