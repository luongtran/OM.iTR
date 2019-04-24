class AddStatusToTasksUsers < ActiveRecord::Migration[5.2]
  def change
  	add_column :tasks_users, :status, :string
  end
end
