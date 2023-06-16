class AddCourseReferenceToClassrooms < ActiveRecord::Migration[7.0]
  def change
    add_reference :classrooms, :course, null: false, foreign_key: true
  end
end
