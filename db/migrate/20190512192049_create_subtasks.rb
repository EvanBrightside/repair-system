class CreateSubtasks < ActiveRecord::Migration[5.2]
  def change
    create_table :subtasks do |t|
      t.string :name
      t.text :description
      t.string :status
      t.string :author
      t.string :executor
      t.date :deadline
      t.references :task, foreign_key: true

      t.timestamps
    end
  end
end
