class AddIsResponsibleToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :is_responsible, :boolean
  end
end
