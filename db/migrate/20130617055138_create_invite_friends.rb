class CreateInviteFriends < ActiveRecord::Migration
  def change
    create_table :invite_friends do |t|
      t.integer :director_id
      t.integer :show_id
      t.integer :contributor_id
      t.string :status

      t.timestamps
    end
  end
end
