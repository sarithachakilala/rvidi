class ApisController < InheritedResources::Base
  before_filter  :except => :index

  belongs_to :documentation
end
