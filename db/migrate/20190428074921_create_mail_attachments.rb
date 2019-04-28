class CreateMailAttachments < ActiveRecord::Migration[5.2]
  def change
    create_table :mail_attachments do |t|
      t.integer :email_id

      t.timestamps
    end
  end
end
