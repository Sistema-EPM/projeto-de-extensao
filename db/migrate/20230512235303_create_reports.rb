class CreateReports < ActiveRecord::Migration[7.0]
  def change
    create_table :reports do |t|
      t.float :reported_effort
      t.date :reported_date
      t.boolean :status
      t.belongs_to :project, null: false, foreign_key: true
      t.belongs_to :student, null: false, foreign_key: true

      t.timestamps
    end
  end
end
