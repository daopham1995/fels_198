class Lesson < ApplicationRecord
  include CreateActivity

  enum status: [:start, :testing, :finish]
  scope :desc, ->{order created_at: :desc}

  belongs_to :category
  belongs_to :user
  belongs_to :level

  has_many :results, dependent: :destroy
  has_many :words, through: :results

  accepts_nested_attributes_for :results

  after_create :create_activities

  def add_results list_word
    list_word.each do |w|
      self.results.create word_id: w.id
    end
    true
  end

  def update_deadline_and_status
    update_attributes deadline: (Time.now + category.duration.to_i.minutes),
      status: Lesson.statuses[:testing]
  end

  def timeout?
    Time.zone.now > deadline
  end

  def create_new_lesson
    status = true
    Lesson.transaction do 
      save
      if !add_easy_word || !add_normal_word || !add_hard_word
        status = false
        raise ActiveRecord::Rollback
      end
    end
    status
  end

  def add_easy_word
    @count_easy= category.question_count.to_i * level.level1.to_i / 100;
    result = Word.by_category_and_level(category.id, @count_easy,
      Word.levels[:easy]);
    result.size < @count_easy ? false : add_results(result)
  end

  def add_normal_word
    @count_normal = category.question_count.to_i * level.level2.to_i / 100;
    result = Word.by_category_and_level(category.id, @count_normal,
      Word.levels[:normal]);
    result.size < @count_normal ? false : add_results(result)
  end

  def add_hard_word
    @count_hard = category.question_count.to_i - @count_easy - @count_normal
    result = Word.by_category_and_level(category.id, @count_hard,
      Word.levels[:hard]);
    result.size < @count_hard ? false : add_results(result)
  end

  private
  def create_activities
    create_activity Activity.types[:start_lesson], id, user_id
  end
end
