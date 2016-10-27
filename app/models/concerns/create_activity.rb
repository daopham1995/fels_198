module CreateActivity
  def create_activity type, target_id, user_id
    Activity.create types: type, target_id: target_id, user_id: user_id
  end
end
