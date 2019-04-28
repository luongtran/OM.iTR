class CreateEmailContents < ActiveRecord::Migration[5.2]
  def change
    create_table :email_contents do |t|
      t.string :subject
      t.string :receiver
      t.text :content

      t.timestamps
    end
  end
end
