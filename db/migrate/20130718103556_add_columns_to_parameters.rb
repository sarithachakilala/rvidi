class AddColumnsToParameters < ActiveRecord::Migration
  def change
    add_column :parameters, :required, :string
    add_column :parameters, :example_values, :text
  end
end
