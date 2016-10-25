class Category < ApplicationRecord
  has_many :lessons, dependent: :destroy
  has_many :words, dependent: :destroy

  validates :name, presence: true
end
