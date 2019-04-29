class Team < ApplicationRecord
	extend FriendlyId

	friendly_id :name, use: :slugged
  	has_many :team_members
	has_many :team_members, class_name: "User"
	belongs_to :owner, class_name: "User", foreign_key: "owner_id"
end
