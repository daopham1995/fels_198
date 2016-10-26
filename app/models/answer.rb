class Answer < ApplicationRecord
  belongs_to :word, inverse_of: :answers

  has_many :results, dependent: :destroy
  scope :is_correct, -> {where is_correct: true}
end
