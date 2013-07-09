class AddContributorEmailToInviteFriends < ActiveRecord::Migration
  def change
    add_column :invite_friends, :contributor_email, :string
  end
end
