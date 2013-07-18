class Documentation < ActiveRecord::Base
  attr_accessible :description, :name
  has_many :apis
end
