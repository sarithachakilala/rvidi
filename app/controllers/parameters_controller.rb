class ParametersController < InheritedResources::Base


  belongs_to :documentation do
    belongs_to :api do
      belongs_to :resource
    end
  end
end