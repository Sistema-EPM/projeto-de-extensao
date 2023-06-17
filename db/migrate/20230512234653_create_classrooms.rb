class CreateClassrooms < ActiveRecord::Migration[7.0]
  def change
    create_table :classrooms do |t|
      t.string :name
      t.date :start_date
      t.date :end_date
      t.boolean :status

      t.timestamps
    end
  end
end
