class User < ActiveRecord::Base
  has_secure_password
  has_many :vehicles

  validates :name,     presence: true,
                       uniqueness: true
  validates :email,    presence: true,
                       uniqueness: true,
                       format: { with: /\w+@\w+\.\w+/ }
  validates :password, presence: true
end