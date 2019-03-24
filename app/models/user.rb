class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_and_belongs_to_many :tasks
  has_many :my_tasks, foreign_key: "created_by", class_name: "Task"
  belongs_to :team

  accepts_nested_attributes_for :team
  validates :email, presence: true, uniqueness: {scope: :team_id}

  has_attached_file :avatar, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\z/
  
  ADMIN_ROLE = "admin"
  STAFF_ROLE = 'staff'

  def admin?
  	self.role == ADMIN_ROLE
  end

  def self.user_existed(email)
    users = User.where(email: email).first
    !users.nil?
  end

end
