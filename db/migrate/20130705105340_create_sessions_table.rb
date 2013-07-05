class CreateSessionsTable < ActiveRecord::Migration
  def up
    create_table :sessions do |t|
      t.string  :session_id
      t.text    :data
      t.timestamps
    end
  end

  def down
    drop_table :sessions
  end
end
