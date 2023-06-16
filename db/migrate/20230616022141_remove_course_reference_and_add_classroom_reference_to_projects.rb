class RemoveCourseReferenceAndAddClassroomReferenceToProjects < ActiveRecord::Migration[7.0]
  def change
    remove_reference :projects, :course, null: false, foreign_key: true
    add_reference :projects, :classroom, null: false, foreign_key: true
  end
end
