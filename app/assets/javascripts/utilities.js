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

  $(".selects-container").on('click','#invite_friend', function(){
  var child_id = [];
    $(".child_ckeck").each(function()
    {   
      var each_id = '#'+this.id;        
       if($('#' + this.id).is(":checked"))
        {
          child_id.push(this.id);
        }           
    });  
    $.ajax({
      url: "/shows/invite_friend.js",
      data: { checked_friends: child_id, page_id: $('#id').val() },
      cache: false,
      dataType: 'script'
    });
  }); 

  // Get the list of friends list based on search criteria
  $('#search_friends').on('click',function(){
    email = $('#search_value').val()
    var regex = /^([a-zA-Z0-9_\.\-\+])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/;
    $.ajax({
      url: "/users/friends_list.js",
      data: { search_val:$('#search_value').val() , email_valid: regex.test(email) },
      cache: false
    });
  }); 
   
  $('#search_friends_to_invite').on('click',function(){
    email = $('#search_value_to_invite').val()
    var regex = /^([a-zA-Z0-9_\.\-\+])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/;
    $.ajax({
      url: "/shows/friends_list.js",
      data: { search_val:$('#search_value_to_invite').val() , email_valid: regex.test(email), page_id: $('#id').val() },
      cache: false
    });
  });     

  $(".links_container").on('click','.display_formats',function(){
    $('.display_formats').removeClass('activeLink ');
    $(this).addClass('activeLink ');
    var req_detail = $(this).attr('id');
    $(".showsformat").hide();
    $("."+req_detail+"_formats").show();
  });


});

function loadANewPage(url){
  // showLightBoxLoading();
  window.location.href=url;
}

// sendAjaxRequest is used to send an xml http request using javascript to a url using a method / get, put, post, delete
function sendAjaxRequest(url, mType){
  methodType = mType || "GET";
  jQuery.ajax({type: methodType, dataType:"script", url:url});
}

// Call this function by passing a heading and a body message.
// it will pop up bootstrap modal with the message.
function showMessageInThePopUp(heading, message){
  $('#div-modal-popup-message .modal-body').html("<p>"+ message +"</p>");
  $("#h3-modal-popup-message-header").text(heading);
  $('#div-modal-popup-message').modal('show');
  $(".btn").button('reset')
}
