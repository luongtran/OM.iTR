class AddEmailContentIdToMailAttachment < ActiveRecord::Migration[5.2]
  def change
    add_column :mail_attachments, :email_content_id, :integer
    remove_column :mail_attachments, :email_id
  end
end
