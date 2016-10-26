class Lesson < ApplicationRecord
  enum status: [:start, :testing, :finish]
  scope :desc, ->{order created_at: :desc}

  belongs_to :category
  belongs_to :user
  belongs_to :level

  has_many :results, dependent: :destroy
  has_many :words, through: :results

  accepts_nested_attributes_for :results

  def add_results list_word
    list_word.each do |w|
      self.results.create word_id: w.id
    end
  end
end
