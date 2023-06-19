class Classroom < ApplicationRecord
  belongs_to :course

  has_many :projects, dependent: :destroy
  has_many :users, dependent: :destroy
end
