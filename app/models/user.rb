class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  belongs_to :organization
  belongs_to :classroom, optional: true

  has_many :reports, dependent: :destroy
  has_many :courses, dependent: :destroy
  has_many :projects, through: :reports, dependent: :destroy
  has_many :assignments, dependent: :destroy
end
