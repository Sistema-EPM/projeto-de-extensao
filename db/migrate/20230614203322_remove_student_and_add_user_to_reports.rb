class RemoveStudentAndAddUserToReports < ActiveRecord::Migration[7.0]
  def change
    remove_reference :reports, :student, null: false, foreign_key: true
    add_reference :reports, :user, null: false, foreign_key: true
  end
end
