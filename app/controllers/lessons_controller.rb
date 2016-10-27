class LessonsController < ApplicationController
  before_action :logged_in_user
  before_action :find_lesson, only: [:show, :update]

  def new
    @lesson = Lesson.new
    @supports = Supports::Lesson.new
  end

  def create
    @lesson = Lesson.new lesson_params
    if @lesson.save
      @lesson.start!
      list_word = Word.by_category @lesson.category_id, @lesson.category.question_count
      @lesson.add_results list_word
      flash[:success] = t "lesson.created"
      redirect_to current_user
    else
      render :new
    end
  end

  def show
    if @lesson.start?
      @lesson.update_deadline_and_status
    elsif @lesson.testing? && @lesson.timeout?
      @lesson.update_attributes score: count_score, status: Lesson.statuses[:finish]
    end 
    @deadline = (@lesson.deadline - Time.now).to_i
  end

  def update
    unless @lesson.finish?
      @lesson.assign_attributes lesson_params.merge status: Lesson.statuses[:finish]
      @lesson.save
      @lesson.update_attributes score: count_score
      redirect_to current_user
    end
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
      results_attributes: [:id, :answer_id, :is_correct]
  end

  def count_score
    @lesson.results.select{|result| result.answer &&
      result.answer.is_correct?}.size
  end
end
