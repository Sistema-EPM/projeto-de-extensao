class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  belongs_to :organization
  belongs_to :classroom, optional: true

  has_many :reports
  has_many :courses
  has_many :projects, through: :reports
  has_many :assignments
end
