class CreatePermalinkForShows < ActiveRecord::Migration
  
  def up
    
    ## Add a new string column to store permalink
    add_column :shows, :permalink, :string, :limit=>128
    
    ## Update all existing entries, set duration = 0.00
    Show.all.each do |s|
      s.create_permalink
    end
    
  end
  
  def down
    
    ## Remove the existing string column to store duration
    remove_column :shows, :permalink
    
  end
  
end
