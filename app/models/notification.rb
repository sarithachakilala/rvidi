class Notification < ActiveRecord::Base
  attr_accessible :content, :from_id, :status, :to_id, :show_id
  validates :from_id, :to_id, :status, :content, :presence => true
end
