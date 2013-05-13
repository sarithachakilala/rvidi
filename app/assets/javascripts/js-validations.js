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

});

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
