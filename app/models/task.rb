class Task < ApplicationRecord
	belongs_to :user, class_name: "User", foreign_key: "created_by", dependent: :destroy
	has_many :tasks_users
	has_many :users, :through => :tasks_users

	def completed?(user_id)
		task = self.tasks_users.where(user_id: user_id).first
		task.present? ? (task.status == "done") : false
	end
end
