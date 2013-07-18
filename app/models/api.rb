class Api < ActiveRecord::Base
  attr_accessible :description, :documentation_id, :name
  belongs_to :documentation
  has_many :resources
end
