class Activity < ApplicationRecord
  belongs_to :user

  enum types: [:follow, :unfollow, :start_lesson]

  validates :target_id, presence: true
  validates :user, presence: true
  scope :by_user, -> ids {where(user_id: ids).order created_at: :desc}
end
