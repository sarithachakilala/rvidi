class AddmMetadataToCameoFIle < ActiveRecord::Migration
  def change
    add_column :cameo_files, :metadata, :text
  end
end
