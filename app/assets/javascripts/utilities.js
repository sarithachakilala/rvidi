$(document).ready(function(){
  $('#myModal').modal('show')

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

  // To get only Checked cameos
  $('#update_cameo').on('click',function(){
    var child_id = [];
    $(".cameo_check").each(function()
    {   
      var each_id = '#'+this.id;        
       if($('#' + this.id).is(":checked"))
        {
          child_id.push(this.id);
        }           
    });  
    $.ajax({
      url: "/cameos/cameo_status",
      data: { checked_cameos: child_id, show_id: $('#id').val()  },
      cache: false
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

  $(document).on('click','.display_formats',function(){
    var container = $(this).parents('.tab-changeable').first()
    container.find('.display_formats').removeClass('active');
    $(this).addClass('active');
    // Script to toggle beetween List and Thumbnail Views
    var req_detail = $(this).prop('id');
    container.find(".showsformat").hide();
    container.find("."+req_detail+"_formats").show();
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

  var _debug = false;
  var _placeholderSupport = function() {
  var t = document.createElement("input");
  t.type = "text";
  return (typeof t.placeholder !== "undefined");
}();

window.onload = function() {
    var arrInputs = document.getElementsByTagName("input");
    for (var i = 0; i < arrInputs.length; i++) {
        var curInput = arrInputs[i];
        if (!curInput.type || curInput.type == "" || curInput.type == "text")
            HandlePlaceholder(curInput);
        else if (curInput.type == "password")
            ReplaceWithText(curInput);
    }

    if (!_placeholderSupport) {
        for (var i = 0; i < document.forms.length; i++) {
            var oForm = document.forms[i];
            if (oForm.attachEvent) {
                oForm.attachEvent("onsubmit", function() {
                    PlaceholderFormSubmit(oForm);
                });
            }
            else if (oForm.addEventListener)
                oForm.addEventListener("submit", function() {
                    PlaceholderFormSubmit(oForm);
                }, false);
        }
    }


function ReplaceWithText(oPasswordTextbox) {
    if (_placeholderSupport)
        return;
    var oTextbox = document.createElement("input");
    oTextbox.type = "text";
    oTextbox.id = oPasswordTextbox.id;
    oTextbox.name = oPasswordTextbox.name;
    //oTextbox.style = oPasswordTextbox.style;
    oTextbox.className = oPasswordTextbox.className;
    for (var i = 0; i < oPasswordTextbox.attributes.length; i++) {
        var curName = oPasswordTextbox.attributes.item(i).nodeName;
        var curValue = oPasswordTextbox.attributes.item(i).nodeValue;
        if (curName !== "type" && curName !== "name") {
            oTextbox.setAttribute(curName, curValue);
        }
    }
    oTextbox.originalTextbox = oPasswordTextbox;
    oPasswordTextbox.parentNode.replaceChild(oTextbox, oPasswordTextbox);
    HandlePlaceholder(oTextbox);
    if (!_placeholderSupport) {
        oPasswordTextbox.onblur = function() {
            if (this.dummyTextbox && this.value.length === 0) {
                this.parentNode.replaceChild(this.dummyTextbox, this);
            }
        };
    }
}

function HandlePlaceholder(oTextbox) {
    if (!_placeholderSupport) {
        var curPlaceholder = oTextbox.getAttribute("placeholder");
        if (curPlaceholder && curPlaceholder.length > 0) {
            Debug("Placeholder found for input box '" + oTextbox.name + "': " + curPlaceholder);
            oTextbox.value = curPlaceholder;
            oTextbox.setAttribute("old_color", oTextbox.style.color);
            oTextbox.style.color = "#c0c0c0";
            oTextbox.onfocus = function() {
                var _this = this;
                if (this.originalTextbox) {
                    _this = this.originalTextbox;
                    _this.dummyTextbox = this;
                    this.parentNode.replaceChild(this.originalTextbox, this);
                    _this.focus();
                }
                Debug("input box '" + _this.name + "' focus");
                _this.style.color = _this.getAttribute("old_color");
                if (_this.value === curPlaceholder)
                    _this.value = "";
            };
            oTextbox.onblur = function() {
                var _this = this;
                Debug("input box '" + _this.name + "' blur");
                if (_this.value === "") {
                    _this.style.color = "#c0c0c0";
                    _this.value = curPlaceholder;
                }
            };
        }
        else {
            Debug("input box '" + oTextbox.name + "' does not have placeholder attribute");
        }
    }
    else {
        Debug("browser has native support for placeholder");
    }
}

function Debug(msg) {
    if (typeof _debug !== "undefined" && _debug) {
        var oConsole = document.getElementById("Console");
        if (!oConsole) {
            oConsole = document.createElement("div");
            oConsole.id = "Console";
            document.body.appendChild(oConsole);
        }
        oConsole.innerHTML += msg + "<br />";
    }
}
};

function PlaceholderFormSubmit(oForm) {    
    for (var i = 0; i < oForm.elements.length; i++) {
        var curElement = oForm.elements[i];
        HandlePlaceholderItemSubmit(curElement);
    }
}

function HandlePlaceholderItemSubmit(element) {
    if (element.name) {
        var curPlaceholder = element.getAttribute("placeholder");
        if (curPlaceholder && curPlaceholder.length > 0 && element.value === curPlaceholder) {
            element.value = "";
            window.setTimeout(function() {
                element.value = curPlaceholder;
            }, 100);
        }
    }
}