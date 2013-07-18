class CreateDocumentations < ActiveRecord::Migration
  def change
    create_table :documentations do |t|
      t.string :name
      t.string :description

      t.timestamps
    end
  end
end
