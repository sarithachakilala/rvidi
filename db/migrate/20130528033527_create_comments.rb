class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.text :body
      t.integer :user_id
      t.string :user_name
      t.integer :show_id

      t.timestamps
    end
  end
end
