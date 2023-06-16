class Classroom < ApplicationRecord
  belongs_to :course

  has_many :projects
end
