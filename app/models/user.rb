class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :tasks_users
  has_many :tasks, :through => :tasks_users
  has_many :my_tasks, foreign_key: "created_by", class_name: "Task"
  belongs_to :team

  accepts_nested_attributes_for :team
  validates :email, presence: true, uniqueness: {scope: :team_id}

  has_attached_file :avatar, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\z/
  
  ADMIN_ROLE = "admin"
  MANAGER_ROLE = "manager"
  STAFF_ROLE = 'staff'

  
  after_create :create_page, :set_role

  def admin?
  	self.role == ADMIN_ROLE
  end

  def manager?
    self.role == MANAGER_ROLE
  end

  def staff?
    self.role == STAFF_ROLE
  end
  def task_editable?
    self.role == ADMIN_ROLE || self.role == MANAGER_ROLE
  end

  def self.user_existed(email)
    users = User.where(email: email).first
    !users.nil?
  end

  def create_page
    if admin?
      Page.create({name: "Welcome", title: "Welcome", destination: "welcome", content: "Welcome to #{self.team.name} App", business_name: self.team.name, team_id: self.team_id})
      Page.create({name: "about", title: "About", destination: "about", content: "About us", business_name: self.team.name, team_id: self.team_id})
    end
  end

  def set_role
    if self.role.nil?
      self.role = ADMIN_ROLE
      self.save
    end
  end

end
