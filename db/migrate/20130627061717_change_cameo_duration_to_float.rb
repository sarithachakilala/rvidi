class ChangeCameoDurationToFloat < ActiveRecord::Migration
  
  def up
    
    ## Remove the existing string column to store duration
    remove_column :cameos, :duration
    
    ## Add a new float column to store duration
    add_column :cameos, :duration, :float
    
    ## Update all existing entries, set duration = 0.00
    Cameo.update_all("duration = 0.00", "")
    
  end
  
  def down
    
    ## Remove the existing string column to store duration
    remove_column :cameos, :duration
    
    ## Add a new float column to store duration
    add_column :cameos, :duration, :string, :limit=>32
    
    ## Update all existing entries, set duration = 0.00
    Cameo.update_all("duration = '0.00'", "")
    
  end
  
end
