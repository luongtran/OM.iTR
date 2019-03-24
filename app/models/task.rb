class Task < ApplicationRecord
	belongs_to :user, class_name: "User", foreign_key: "created_by", dependent: :destroy
end
