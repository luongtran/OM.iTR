class ConvertRelationship < ActiveRecord::Migration[5.2]
  def change
  	create_table :tasks_users_tmps do |t|
      t.belongs_to :task, :null => false, :index => true
      t.belongs_to :user, :null => false, :index => true
    end
  end
end
