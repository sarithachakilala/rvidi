class RemoveTagsFromCameos < ActiveRecord::Migration
  def up
    remove_column :cameos, :tags
  end

  def down
    add_column :cameos, :tags, :string
  end
end
