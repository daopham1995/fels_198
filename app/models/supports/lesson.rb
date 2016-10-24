class Supports::Lesson
  def categories
    Category.all.collect{|category| [category.name, category.id]}
  end

  def levels
    Level.all.collect{|level| [level.name, level.id]}
  end
end
