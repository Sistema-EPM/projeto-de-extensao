class Organization < ApplicationRecord
  has_many :users, dependent: :destroy
  has_many :projects, dependent: :destroy

  belongs_to :admin

  validates :name, presence: true
end
