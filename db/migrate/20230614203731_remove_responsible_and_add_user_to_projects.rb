class RemoveResponsibleAndAddUserToProjects < ActiveRecord::Migration[7.0]
  def change
    remove_reference :projects, :responsible, null: false, foreign_key: true
    add_reference :projects, :user, null: false, foreign_key: true
  end
end
