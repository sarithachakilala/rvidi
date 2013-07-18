class AddColumnsToResources < ActiveRecord::Migration
  def change
    add_column :resources, :http_method, :string
    add_column :resources, :sample_response, :text
    add_column :resources, :url, :text
  end
end
