class Supports::Word
  attr_reader :word

  def initialize word
    @word = word
  end

  def levels
    @levels ||= Word.levels
  end

  def categories
    @categories ||= Category.all.collect{|category| [category.name, category.id]}
  end
end
