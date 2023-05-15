class CreateArchives < ActiveRecord::Migration[7.0]
  def change
    create_table :archives do |t|
      t.string :title
      t.string :path
      t.string :original_name
      t.string :type
      t.string :size
      t.belongs_to :report, null: false, foreign_key: true

      t.timestamps
    end
  end
end
