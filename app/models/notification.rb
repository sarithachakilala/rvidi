class Notification < ActiveRecord::Base

  #Validations
  validates :from_id, :status, :content, :presence => true
  validates :to_email, :presence => {:unless => "to_id"}
  validates :to_id, :presence => {:unless => "to_email"}

  # Associations

  belongs_to :show

end
