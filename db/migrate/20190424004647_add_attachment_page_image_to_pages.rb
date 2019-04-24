class AddAttachmentPageImageToPages < ActiveRecord::Migration[5.2]
  def self.up
    change_table :pages do |t|
      t.attachment :page_image
    end
  end

  def self.down
    remove_attachment :pages, :page_image
  end
end
