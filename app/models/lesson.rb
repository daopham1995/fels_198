class Lesson < ApplicationRecord
  enum status: [:unfinish, :finish]

  belongs_to :category
  belongs_to :user
  belongs_to :level

  has_many :results, dependent: :destroy
  has_many :words, through: :results

  accepts_nested_attributes_for :results
end
