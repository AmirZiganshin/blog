class Model1 < ApplicationRecord
  enum role: {user: 0, moderator: 1, admin: 2}
  after_initialize :set_default_role, :if => :new_record?
  def set_default_role
    self.role ||= :user
  end
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :rememberable, :validatable
end
