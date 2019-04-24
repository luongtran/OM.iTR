class CopyUsersTasks < ActiveRecord::Migration[5.2]
  class User < ActiveRecord::Base
	  has_and_belongs_to_many :tasks
	  has_many :tasks_users_tmps
	  has_many :task_tmps, :through => :tasks_users_tmps, :source => :task
   end
    class Task < ActiveRecord::Base
      has_and_belongs_to_many :users
      has_many :tasks_users_tmps
      has_many :user_tmps, :through => :tasks_users_tmps, :source => :user
    end
    class TasksUsersTmp < ActiveRecord::Base
      belongs_to :task
      belongs_to :user
    end

    def up
      Task.find_each do |task|
        task.user_tmps = task.users
      end
    end

    def down
    end
end
