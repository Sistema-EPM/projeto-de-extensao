class Project < ApplicationRecord
  belongs_to :course
  belongs_to :responsible
  belongs_to :ods_project
  belongs_to :feedback
  belongs_to :organization
end
