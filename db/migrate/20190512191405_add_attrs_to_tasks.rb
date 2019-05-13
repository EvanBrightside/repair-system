class AddAttrsToTasks < ActiveRecord::Migration[5.2]
  def change
    add_column :tasks, :deadline, :date
    add_column :tasks, :author, :string
    add_column :tasks, :executor, :string
  end
end
