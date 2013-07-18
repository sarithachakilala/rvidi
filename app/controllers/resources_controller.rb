class ResourcesController < InheritedResources::Base
  before_filter :except => [:index, :show]
  belongs_to :documentation do
    belongs_to :api
  end
end
