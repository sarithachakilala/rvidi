$(document).ready(function(){
  //    To Change the + / - icon on click
  $('.plus-minus-container').on('click','.changeable-plus-minus',function(){
    var icon_elem = $(this).find('.plus-minus-i').first()
    if($(this).hasClass('collapsed')){            
      icon_elem.removeClass('sprite-plus-small')
      icon_elem.addClass('sprite-minus-small')
    }else{
      icon_elem.removeClass('sprite-minus-small')
      icon_elem.addClass('sprite-plus-small')
    }
  });

  //    To highlight labels on selecting the radio buttons
  $('div.radio-inputs-container').on('click','input.radio-input',function(){
    var container = $(this).parents('.radio-inputs-container').first();        
    var all_label_elems = container.find('label.radio');
    var label_elem = $(this).parents('.radio').first();
            
    $.each(all_label_elems, function(i, elem){
      $(elem).removeClass('radiobtn_active_text');
      $(elem).addClass('radiobtn_inactive_text');
    });
    label_elem.removeClass('radiobtn_inactive_text');
    label_elem.addClass('radiobtn_active_text');
  });
       
  //    To Select All Chack Boxes
  $('.selects-container').on('click','.select-all-label',function(){
    var selects_container = $(this).parents('.selects-container').first();
    var all_selects = selects_container.find('.checkbox-input');
    if($(selects_container).hasClass('checked-all')){
      $.each(all_selects, function(i, elem){
        $(elem).prop('checked',false);
        $(selects_container).removeClass('checked-all');
      });
    }else{
      $.each(all_selects, function(i, elem){
        $(elem).prop('checked',true);
        $(selects_container).addClass('checked-all');
      });
    }
  });       

  // Get the list of friends list based on search criteria
  $('#search_friends').on('click',function(){
    $.ajax({
          url: "/users/friends_list.js",
          data: { search_val:$('#search_value').val()  },
           cache: false
      })    
  });       
});

function loadKalturaVideo(show_id, kaltura_entry_id){

    // <script src="http://cdnapi.kaltura.com/p/1409052/sp/140905200/embedIframeJs/uiconf_id/14018252/partner_id/1409052?autoembed=true&entry_id=<%= cameo.kaltura_entry_id %>&playerId=kaltura_player_<%= cameo.show_id %>&cache_st=1368767278&width=526&height=353">
    // </script>

}