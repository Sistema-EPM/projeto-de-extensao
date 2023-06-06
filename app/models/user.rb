class User < ApplicationRecord
  belongs_to :organization

  has_many :reports
  has_many :projects, through: :reports
end
