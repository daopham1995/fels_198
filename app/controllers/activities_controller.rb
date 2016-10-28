class ActivitiesController < ApplicationController
  def index
    ids = current_user.following.ids
    ids.push current_user.id
    @activities = Activity.by_user(ids).paginate page: params[:page]
    respond_to do |format|
      format.json {render json: json_notify}
      format.html
    end
  end

  private
  def json_notify
    data = @activities.collect do |activity|
      {user: activity.user.name,
        action: activity.types,
        target: lesson_name(activity.target_id)}
    end
    data.to_json
  end

  def user_name id
    user = User.find_by_id id
    user.nil? ? t("activity.unknow") : user.name
  end

  def lesson_name id
    lesson = Lesson.find_by_id id
    lesson.nil? ? t("activity.unknow") : lesson.category.name
  end
end
