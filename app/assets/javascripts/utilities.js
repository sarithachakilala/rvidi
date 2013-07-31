$(document).ready(function(){
  if($("#myModal").length>0){
    $('#myModal').modal('show');
  }
  $( "#sortable" ).sortable();
  $( "#sortable" ).disableSelection();

  
  checking_display_pwd_field();
  checking_contributor_pwd_field();
  
  $(".show-display-preferences").on('click',function(){
    checking_display_pwd_field();
  });

  $(".show-contributor-preferences").on('click',function(){
    checking_contributor_pwd_field();
  });

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

  //    To Select All Check Boxes
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

  $(".clip_video").on('click', function(event){
    event.preventDefault();
    if ($('#cameo_start_time').val()=="" || $('#cameo_end_time').val()=="")
    {
      alert("Please enter timings to clip the video")
    }
    else{
      alert("your cameo will be clipped shortly")
    }
    jQuery.ajax({
      url: "/cameos/cameo_clipping",
      data: {
        start_time: $('#cameo_start_time').val(),
        end_time: $('#cameo_end_time').val() ,
        selected_cameo : $('#selected_cameo').val()
      },
      dataType: 'script',
      cache: false,
      beforeSend: function() {
        $('#ajax-indicator').show();
      },
      complete: function() {
        $('#ajax-indicator').hide();
      }
    });
    
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
      data: {
        checked_friends: child_id,
        page_id: $('#id').val()
      },
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
      data: {
        search_val:$('#search_value').val() ,
        email_valid: regex.test(email)
      },
      cache: false
    });
  }); 

  $('#search_friends_to_invite').on('click',function(){
    email = $('#search_value_to_invite').val()
    var regex = /^([a-zA-Z0-9_\.\-\+])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/;
    $.ajax({
      url: "/shows/friends_list.js",
      data: {
        search_val:$('#search_value_to_invite').val() ,
        email_valid: regex.test(email),
        page_id: $('#id').val()
      },
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
  jQuery.ajax({
    type: methodType,
    dataType:"script",
    url:url
  });
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
      ReplaceWithText(curInput);
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
function check_file(){
  str=document.getElementById('fileToUpload').value.toUpperCase();
  suffix=".MP4";
  suffix2=".MOV";
  suffix3=".AVI";
  suffix4=".FLV";
  suffix5=".WMV";
  suffix6=".3GP";
  suffix7=".ASF";
  suffix8=".SWF";
  suffix9=".WEBM";
  suffix10=".MMKV";
  suffix11=".M4V";
  suffix12=".VOB";
  suffix13=".RM";
  suffix14=".DIVX";
  if(!(str.indexOf(suffix, str.length - suffix.length) !== -1||
    str.indexOf(suffix2, str.length - suffix2.length) !== -1 ||
    str.indexOf(suffix3, str.length - suffix3.length) !== -1 ||
    str.indexOf(suffix4, str.length - suffix4.length) !== -1 ||
    str.indexOf(suffix5, str.length - suffix5.length) !== -1 ||
    str.indexOf(suffix6, str.length - suffix6.length) !== -1 ||
    str.indexOf(suffix7, str.length - suffix7.length) !== -1 ||
    str.indexOf(suffix8, str.length - suffix8.length) !== -1 ||
    str.indexOf(suffix9, str.length - suffix9.length) !== -1 ||
    str.indexOf(suffix10, str.length - suffix10.length) !== -1 ||
    str.indexOf(suffix11, str.length - suffix11.length) !== -1 ||
    str.indexOf(suffix12, str.length - suffix12.length) !== -1 ||
    str.indexOf(suffix13, str.length - suffix13.length) !== -1 ||
    str.indexOf(suffix14, str.length - suffix14.length) !== -1)){
    alert('File type not allowed\n');
    document.getElementById('fileToUpload').value='';
    return false;
  }

  else {
    return true;
  }
  
}

$(function() {
  $( "#sortable" ).sortable({
    stop: function(){
      var listItem = $("div#sortable div.each_detail")
      var listLength = listItem.length;
      var list = [];
      for(var i=0; i<listLength; i++){
        // list[i] = listItem[i].id;}
        list[i] = $(listItem[i]).attr('data-id');
      }
      document.getElementById("order_list").value = list
    }
  });
  $( "#sortable" ).disableSelection();
});


// Presently not using.
function sortList() {
  var listItem = $("div#sortable div.each_detail")
  var listLength = listItem.length;
  var list = [];
  for(var i=0; i<listLength; i++){
    // list[i] = listItem[i].id;}
    list[i] = $(listItem[i]).attr('data-id');
  }
  document.getElementById("order_list").value = list
}

function checking_display_pwd_field(){
  if ($("#show_display_preferences_password_protected").is(":checked"))
    $("#show_display_preferences_password").css("display","block");
  else{
    $('#display_public_password_Error').css("display","none");
    $("#show_display_preferences_password").css("display","none");
  }
}

function checking_contributor_pwd_field(){
  if ($("#show_contributor_preferences_password_protected").is(":checked"))
    $("#show_contributor_preferences_password").css("display","block");
  else{
    $('#contributor_public_password_Error').css("display","none");
    $("#show_contributor_preferences_password").css("display","none");
  }
}


function readURL(input) {
  var filename = $(input).val().split('\\').pop();
  var status = validate_file_extn(filename);
  var reader = '';

  if(status == "false") {
    alert("File type is not supported");
  }
  else {

    if(navigator.userAgent.match(/msie/i) && !navigator.userAgent.match(/msie 10/i)) {
      if($('.jane_image').length > 0) {
        $('.jane_image').css('border', '1px solid lightgray').html(filename);
      }
    }
    else if(navigator.userAgent.match(/msie/i) && navigator.userAgent.match(/msie 10/i)) {
      reader = new FileReader();
      reader.onload = function (e) {
        $('#rvidi_user_profile_image')
        .attr('src', e.target.result)
        .width(90)
        .height(90);
      };

      reader.readAsDataURL(input.files[0]);
    }

    else {

      if (input.files && input.files[0]) {
        if(input.files[0].size < 1400000) {
          reader = new FileReader();
          reader.onload = function (e) {
            $('#rvidi_user_profile_image')
            .attr('src', e.target.result)
            .width(90)
            .height(90);
          };

          reader.readAsDataURL(input.files[0]);
        }
        else {
          alert("Maximum Size is 1400KB");
        }

      }
    }
  }

}