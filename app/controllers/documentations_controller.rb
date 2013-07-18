class DocumentationsController < InheritedResources::Base
  before_filter  :except => :index
end
