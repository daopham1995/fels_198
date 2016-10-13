class CreateActivities < ActiveRecord::Migration[5.0]
  def change
    create_table :activities do |t|
      t.string :activity_type
      t.string :content
      t.references :user, foreign_key: true

      t.timestamps
    end
    add_index :activities, [:user_id, :created_at]
  end
end
