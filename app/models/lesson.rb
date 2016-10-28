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
  end

  def update_deadline_and_status
    update_attributes deadline: (Time.now + category.duration.to_i.minutes),
      status: Lesson.statuses[:testing]
  end

  def timeout?
    Time.zone.now > deadline
  end

  private
  def create_activities
    create_activity Activity.types[:start_lesson], id, user_id
  end
end
