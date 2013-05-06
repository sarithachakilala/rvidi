class Show
  include Mongoid::Document
  include Mongoid::Timestamps

  # Fields Declaration
  field :user_id, type: Integer
  field :title, type: String
  field :description, type: String
  attr_accessible :user_id, :title, :description

  # Validations
  validates :user_id, :presence => true
  validates :title, :presence => true
  validates :description, :presence => true

  # Associations
  belongs_to :user

end
