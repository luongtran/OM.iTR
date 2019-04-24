class Page < ApplicationRecord
	has_attached_file :page_image, styles: { large: "900x600>", thumb: "250x250>" }, default_url: "/images/:style/missing.png"
	validates_attachment_content_type :page_image, content_type: /\Aimage\/.*\z/
end
