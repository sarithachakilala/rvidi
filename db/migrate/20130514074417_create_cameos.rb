class CreateCameos < ActiveRecord::Migration
  def change
    create_table :cameos do |t|
      t.integer :user_id
      t.integer :director_id
      t.integer :show_id
      t.integer :show_order
      t.string :status
      t.string :name
      t.string :description
      t.string :thumbnail_url
      t.string :download_url
      t.string :duration
      t.string :kaltura_entry_id

      t.timestamps
    end
  end
end
