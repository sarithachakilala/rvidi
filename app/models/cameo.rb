class Cameo < ActiveRecord::Base
  attr_accessible :director_id, :show_id, :show_order, :status, :user_id, :video_id
end
