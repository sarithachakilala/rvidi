class CreateParameters < ActiveRecord::Migration
  def change
    create_table :parameters do |t|
      t.string :name
      t.string :description
      t.integer :resource_id

      t.timestamps
    end
  end
end
