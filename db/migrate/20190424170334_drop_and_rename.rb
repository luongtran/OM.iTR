class DropAndRename < ActiveRecord::Migration[5.2]
  def change
  	drop_table :tasks_users
  	rename_table :tasks_users_tmps, :tasks_users
  end
end
