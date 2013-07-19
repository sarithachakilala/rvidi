class Parameter < ActiveRecord::Base
  attr_accessible :description, :name, :resource_id,:required,:example_values
end
