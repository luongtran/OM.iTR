class CreateTeamMembers < ActiveRecord::Migration[5.2]
  def change
    create_table :team_members do |t|
      t.references :team, foreign_key: true
      t.integer :user_id

      t.timestamps
    end
  end
end
