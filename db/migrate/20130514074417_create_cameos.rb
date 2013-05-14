class CreateCameos < ActiveRecord::Migration
  def change
    create_table :cameos do |t|
      t.integer :video_id
      t.integer :user_id
      t.integer :director_id
      t.string :status
      t.integer :show_id
      t.integer :show_order

      t.timestamps
    end
  end
end
