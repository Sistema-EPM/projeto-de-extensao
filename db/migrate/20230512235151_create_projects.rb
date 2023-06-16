class CreateProjects < ActiveRecord::Migration[7.0]
  def change
    create_table :projects do |t|
      t.string :name
      t.string :competency
      t.string :status
      t.string :modality
      t.text :description
      t.belongs_to :course, null: false, foreign_key: true
      t.belongs_to :responsible, null: false, foreign_key: true
      t.belongs_to :ods_project, null: false, foreign_key: true
      t.belongs_to :feedback, null: true, foreign_key: true
      t.belongs_to :organization, null: false, foreign_key: true

      t.timestamps
    end
  end
end
