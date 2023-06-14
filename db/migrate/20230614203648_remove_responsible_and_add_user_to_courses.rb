class RemoveResponsibleAndAddUserToCourses < ActiveRecord::Migration[7.0]
  def change
    remove_reference :courses, :responsible, null: false, foreign_key: true
    add_reference :courses, :user, null: false, foreign_key: true
  end
end
