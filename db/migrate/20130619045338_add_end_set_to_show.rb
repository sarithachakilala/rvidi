class AddEndSetToShow < ActiveRecord::Migration
  def change
    add_column :shows, :end_set, :datetime
  end
end
