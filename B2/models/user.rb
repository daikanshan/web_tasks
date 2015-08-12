class User < ActiveRecord::Base

  validates :name, :password, presence: true
  validates :name, uniqueness: true
  validates :name, length:{in: 2..10}
  has_secure_password
  validates :password ,length:{in: 6..20}
end