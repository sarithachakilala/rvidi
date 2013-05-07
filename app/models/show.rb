class Show < ActiveRecord::Base

  attr_accessible :user_id, :title, :description

  # Validations
  validates :user_id, :presence => true
  validates :title, :presence => true
  validates :description, :presence => true

  # Associations
  belongs_to :user

end
