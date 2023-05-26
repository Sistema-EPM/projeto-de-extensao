class Student < ApplicationRecord
  has_many :reports
  has_many :projects, through: :reports
end
