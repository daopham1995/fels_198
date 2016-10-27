class Relationship < ApplicationRecord
  include CreateActivity

  after_save :create_follow_activity
  before_destroy :create_unfollow_activity

  belongs_to :follower, class_name: User.name
  belongs_to :followed, class_name: User.name

  validates :follower, presence: true
  validates :followed, presence: true

  private
  def create_follow_activity
    create_activity Activity.types[:follow], followed_id, follower_id
  end

  def create_unfollow_activity
    create_activity Activity.types[:unfollow], followed_id, follower_id
  end
end
