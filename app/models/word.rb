class Word < ApplicationRecord
  belongs_to :category
  scope :by_category, -> (id, count) {where(category_id: id).limit count}
  
  has_many :answers, inverse_of: :word, dependent: :destroy
  has_many :results, dependent: :destroy
  has_many :lessons, through: :results

  validates :question, presence: true
  validate :check_answer_nil
  validate :must_have_two_answer
  validate :check_before_update, on: :update

  accepts_nested_attributes_for :answers,
    allow_destroy: true,
    reject_if: lambda {|attributes| attributes[:content].blank?}

  enum levels: [:easy, :normal, :hard]

  scope :filter_by_category, -> category_id{where category_id: 
    category_id if category_id.present?}
  scope :filter_by_level, -> level{where levels: level if level.present? }
  scope :all_word, -> user_id{}
  scope :learned, -> user_id{where(Settings.sql.word_learned, user_id)}
  scope :not_learned, -> user_id{where(Settings.sql.word_not_learned, user_id)}

  def has_correct_answer?
    correct_answer = answers.is_correct
    correct_answer.size > 0 ? true : false
  end

  private

  def must_have_two_answer
    errors.add :answer, I18n.t("error.answer_size") if answers.size < 2
  end

  def check_answer_nil
    correct_answer = 
      answers.select{|answers|answers.is_correct? && !answers.marked_for_destruction?}
    errors.add :correct_answer,
      I18n.t("error.answer_nil") if correct_answer.empty?
    errors.add :correct_answer,
      I18n.t("error.answer_more_than_2") if correct_answer.size > 1
  end

  def check_before_update
    answers.each do |answer|
      if answer.is_correct? && answer.marked_for_destruction?
        errors.add :correct_answer, I18n.t("error.delete_true_answer")
      end
    end
  end
end
