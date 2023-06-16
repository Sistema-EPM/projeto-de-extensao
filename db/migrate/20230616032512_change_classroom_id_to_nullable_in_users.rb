class ChangeClassroomIdToNullableInUsers < ActiveRecord::Migration[7.0]
  def change
    remove_foreign_key :users, :classrooms
    change_column :users, :classroom_id, :integer, null: true
    add_foreign_key :users, :classrooms, column: :classroom_id
  end
end
