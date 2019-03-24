class CreateTeams < ActiveRecord::Migration[5.2]
  def change
    create_table :teams do |t|
      t.string :name
      t.integer :plan_id
      t.integer :owner_id

      t.timestamps
    end
  end
end
