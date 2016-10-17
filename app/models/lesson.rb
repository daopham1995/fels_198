class Lesson < ApplicationRecord
  belongs_to :category
  belongs_to :user
  belongs_to :level

  has_many :results, dependent: :destroy
  has_many :words, through: :results
end
