class Show
  include Mongoid::Document

  # Fields Declaration
  field :user_id, type: Integer
  field :title, type: String
  field :description, type: String
  attr_accessible :email, :password, :password_confirmation, :remember_me

  # Validations
  validates :user_id, :presence => true
  validates :title, :presence => true
  validates :description, :presence => true

  # Associations
  belongs_to :user

end
