class Result < ApplicationRecord
  belongs_to :word
  belongs_to :lesson
  belongs_to :answer
end
