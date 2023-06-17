class AddFileToReports < ActiveRecord::Migration[7.0]
  def change
    add_column :reports, :file, :string
  end
end
