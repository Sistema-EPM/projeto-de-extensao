class AddReferenceClassroomToUsers < ActiveRecord::Migration[7.0]
  def change
    add_reference :users, :classroom, null: false, foreign_key: true
  end
end
