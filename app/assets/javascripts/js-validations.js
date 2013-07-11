var status;
// Generic Form Validations.
$(document).ready(function(){

  $(document).on('submit', 'form.js-validated-form',function(event){
    // event.preventDefault();
    var errors = validateRequiredFields($(this));
    if (errors == 0){
      // $(this).submit();
      return true;
    }else{
      return false;
    }
  });

  $('#edit-password').on('click', function(event){
    status = "true";
    status = edit_password_validate();
    if(status == "false") {
      event.preventDefault();
    }
    else {
      return;
    }
  });
  $('#update_cameo,#validate_new_show').on('click', function(event){
    status = "true";
    $(this).closest('form').attr('action', '/shows').
            addClass('js-validated-form').attr('target', '_self');
    status = edit_show();
    if(status == "false") {
      event.preventDefault();
    }
    else {
      return;
    }
  });
});

$(document).on('click', '#validate_new_cameo', function(){
  $(this).closest('form').attr('action', '/cameos').
            addClass('js-validated-form').attr('target', '_self');
});

function edit_show()
{
  var dispalay_password =  $('#show_display_preferences_password').val();
  var contributor_password =  $('#show_display_preferences_password').val();

  if( $('#show_contributor_preferences_public').is(":checked") && !$('#show_need_review').is(":checked") ) {
    $('#CheckingError').show();
    $('#CheckingError').html("As your show contribution is public.. let me review is mandatory")
    status = "false";
  }
  else
  {
    $('#CheckingError').hide();
  }
  if( $('#show_display_preferences_password_protected').is(":checked") && dispalay_password == '' ) {
    $('#display_public_password_Error').show();
    $('#display_public_password_Error').html("Please enter password")
    status = "false";
  }
  else
  {
    $('#display_public_password_Error').hide();
  }
  if( $('#show_contributor_preferences_password_protected').is(":checked") && contributor_password == '' ) {
    $('#contributor_public_password_Error').show();
    $('#contributor_public_password_Error').html("Please enter password")
    status = "false";
  }
  else
  {
    $('#contributor_public_password_Error').hide();
  }
  return status;
}
function edit_password_validate()
{
  var password   = $('#user_password').val();
  var confirmation_password  = $('#user_password_confirmation').val();
 
  if(password == '' ) {
    $('#PasswordError').show();
    $('#PasswordError').html("Can't be blank")
    status = "false";
  }
  else 
  {
    $('#PasswordError').hide();
  }
  if(confirmation_password == '')
  {
    $('#ConfirmationPasswordError').show();
    $('#ConfirmationPasswordError').html("Can't be blank")
    status = "false";
  }
  else if((password != '' && confirmation_password != '') && (password !=  confirmation_password ) )
  {
    $('#ConfirmationPasswordError').show();
    $('#ConfirmationPasswordError').html("Password doesn't match")
    status = "false";
  }
  else {
    $('#ConfirmationPasswordError').hide();
  }
  return status;
}


function validateRequiredFields(form){  
  var error_count = 0;
  var required_fields = $(form).find(".js-required");
  $.each(required_fields, function(index, value){
    if(($(value).val() == '') || ($(value).val()==undefined)){
      if($(value).siblings(".error-message").length > 0){
        $(value).siblings(".error-message").first().html("Can't be blank")
      }else{
        $(value).after("<span class='error-message'>Can't be blank</span>")
      }
      error_count += 1;
    }else{
      $(value).siblings(".error-message").first().remove();
    }
  });
  return error_count;
}
