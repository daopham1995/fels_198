module LessonsHelper
  def item_correct? result, answer
    result.lesson.finish? && answer.is_correct?
  end

  def item_incorrect? result, answer
    result.lesson.finish? && 
      result.answer_id == answer.id && !answer.is_correct?
  end
end
