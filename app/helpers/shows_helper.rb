module ShowsHelper
  
  def radio_label_class(show, field, val)
    (show.send(field.to_sym)==val) ? 'radiobtn_active_text' : 'radiobtn_inactive_text'    
  end

	# counts the number of shows uploaded by an user
  def shows_count(user_id)
  	Show.where(:user_id => user_id).count
	end

	# counts the number of cameos uploaded by an user
	def cameos_count(user_id)
    Cameo.where(:director_id => user_id).count
  end
  
end
