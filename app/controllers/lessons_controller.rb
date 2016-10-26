class LessonsController < ApplicationController
  before_action :logged_in_user
  before_action :find_lesson, only: [:show]

  def new
    @lesson = Lesson.new
    @supports = Supports::Lesson.new
  end

  def create
    @lesson = Lesson.new lesson_params
    if @lesson.save
      list_word = Word.by_category @lesson.category_id, @lesson.category.question_count
      @lesson.add_results list_word
      flash[:success] = t "lesson.created"
      redirect_to current_user
    else
      render :new
    end
  end

  def show

  end

  private
  def find_lesson
    @lesson = Lesson.find_by id: params[:id]
    if @lesson.nil?
      flash.now[:danger] = t :error
      redirect_to @lesson.user
    end
  end

  def lesson_params
    params.require(:lesson).permit :user_id, :category_id, :level_id,
      :duration, :question_count, results_attributes: [:id, :answer_id, :is_correct]
  end
end
