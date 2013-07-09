class InviteFriend < ActiveRecord::Base
  attr_accessible :contributor_id, :director_id, :show_id, :status, :contributor_email
end
