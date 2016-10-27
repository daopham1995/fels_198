class AddDeadlineToLessons < ActiveRecord::Migration[5.0]
  def change
    add_column :lessons, :deadline, :datetime
  end
end
