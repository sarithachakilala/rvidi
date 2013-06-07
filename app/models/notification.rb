class Notification < ActiveRecord::Base

  attr_accessible :content, :from_id, :status, :to_id, :show_id, :read_status, :to_email

  #Validations
  validates :from_id, :status, :content, :presence => true
  validates :to_email, :presence => {:unless => "to_id"}
  validates :to_id, :presence => {:unless => "to_email"}

end
