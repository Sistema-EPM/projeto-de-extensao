class AddStatusToStudent < ActiveRecord::Migration[7.0]
  def change
    add_column :students, :status, :boolean
  end
end
