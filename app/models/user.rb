class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :validatable

  validates :first_name, :last_name, :email, :password, :password_confirmation, presence: true

  def full_user_name
    "#{first_name} #{last_name}"
  end
end
