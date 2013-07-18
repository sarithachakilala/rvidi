class AddColumnToResources < ActiveRecord::Migration
  def change
    add_column :resources, :api_id, :integer
  end
end
