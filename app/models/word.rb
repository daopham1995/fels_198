class Word < ApplicationRecord
  belongs_to :category
  
  has_many :answers, inverse_of: :word, dependent: :destroy
  has_many :results, dependent: :destroy
  has_many :lessons, through: :results

  validates :question, presence: true
  validate :check_answer_nil
  validate :must_have_two_answer

  accepts_nested_attributes_for :answers,
    allow_destroy: true,
    reject_if: lambda {|attributes| attributes[:content].blank?}

  enum levels: [:easy, :normal, :hard]

  private

  def must_have_two_answer
    errors.add :answer, I18n.t("error.answer_size") if answers.size < 2
  end

  def check_answer_nil
    correct_answer = answers.select {|answers| answers.is_correct?}
    errors.add :correct_answer,
      I18n.t("error.answer_nil") if correct_answer.empty?
    errors.add :correct_answer,
      I18n.t("error.answer_more_than_2") if correct_answer.size > 1
  end
end
