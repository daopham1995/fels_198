class Activity < ApplicationRecord
  belongs_to :user

  enum types: [:follow, :unfollow, :start_lesson]

  validates :target_id, presence: true
  validates :user, presence: true
end
