module ShowsHelper
  
  def radio_label_class(show, field, val)
    (show.send(field.to_sym)==val) ? 'radiobtn_active_text' : 'radiobtn_inactive_text'    
  end

end
