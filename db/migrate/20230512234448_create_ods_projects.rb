class CreateOdsProjects < ActiveRecord::Migration[7.0]
  def change
    create_table :ods_projects do |t|
      t.string :name

      t.timestamps
    end
  end
end
