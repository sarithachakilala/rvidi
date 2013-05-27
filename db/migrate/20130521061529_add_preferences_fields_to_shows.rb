class AddPreferencesFieldsToShows < ActiveRecord::Migration
  def change
    add_column :shows, :display_preferences, :string
    add_column :shows, :display_preferences_password, :string
    add_column :shows, :contributor_preferences, :string
    add_column :shows, :contributor_preferences_password, :string
    add_column :shows, :need_review, :boolean, :default => true
  end
end
