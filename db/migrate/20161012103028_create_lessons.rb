class CreateLessons < ActiveRecord::Migration[5.0]
  def change
    create_table :lessons do |t|
      t.string :duration
      t.string :spend_time
      t.integer :question_count
      t.integer :status
      t.integer :score
      t.references :category, foreign_key: true
      t.references :user, foreign_key: true
      t.references :level, foreign_key: true

      t.timestamps
    end
  end
end
