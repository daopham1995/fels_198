module ActivitiesHelper
  def user_name id
    user = User.find_by_id id
    user.nil? ? t("activity.unknow") : user.name
  end

  def lesson_name id
    lesson = Lesson.find_by_id id
    lesson.nil? ? t("activity.unknow") : lesson.category.name
  end
end
