class Answer < ApplicationRecord
  belongs_to :word, inverse_of: :answers

  has_many :results, dependent: :destroy
end
