class Project < ApplicationRecord
  # belongs_to :course
  # belongs_to :responsible
  belongs_to :user
  belongs_to :ods_project
  belongs_to :feedback, optional: true
  belongs_to :organization
  belongs_to :classroom

  has_many :reports
  has_many :users, through: :reports
end
