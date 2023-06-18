class Project < ApplicationRecord
  belongs_to :user
  belongs_to :ods_project, optional: true
  belongs_to :feedback, optional: true
  belongs_to :organization
  belongs_to :classroom

  has_many :reports
  has_many :users, through: :reports
  has_many :assignments

  validates :status, inclusion: { in: ["Aguardando", "Em andamento", "Rejeitado", "Encerrado"] }
end
