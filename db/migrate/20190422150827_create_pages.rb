class CreatePages < ActiveRecord::Migration[5.2]
  def change
    create_table :pages do |t|
      t.string :name
      t.string :destination
      t.integer :team_id
      t.text :title
      t.text :content
      t.text :business_name

      t.timestamps
    end
  end
end
