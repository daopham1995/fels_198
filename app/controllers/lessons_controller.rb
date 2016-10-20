class LessonsController < ApplicationController
  before_action :logged_in_user
  before_action :find_lesson, only: [:show]

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
end
