class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.integer :from_id
      t.integer :to_id
      t.integer :show_id
      t.text :content
      t.string :status
      t.string :to_email
      t.boolean :read_status, :default =>false

      t.timestamps
    end
  end
end
