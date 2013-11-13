class AddFiletoCameoFile < ActiveRecord::Migration
  def up
    add_column :cameo_files, :file, :string
  end

  def down
    remove_column :cameo_files, :file
  end
end
