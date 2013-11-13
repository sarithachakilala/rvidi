class AddOriginalFileNameToCameoFile < ActiveRecord::Migration
  def change
    add_column :cameo_files, :original_filename, :string
  end
end
