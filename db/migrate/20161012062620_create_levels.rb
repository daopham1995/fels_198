class CreateLevels < ActiveRecord::Migration[5.0]
  def change
    create_table :levels do |t|
      t.string :name
      t.string :level1
      t.string :level2
      t.string :level3

      t.timestamps
    end
  end
end
