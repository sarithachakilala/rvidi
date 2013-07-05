jQuery(document).ready(function($){
  $('.popup').click(function(event) {
    event.preventDefault();
    var width  = 575,
    height = 400,
    left   = ($(window).width()  - width)  / 2,
    top    = ($(window).height() - height) / 2,
    url    = this.href,
    opts   = 'status=1' +
    ',width='  + width  +
    ',height=' + height +
    ',top='    + top    +
    ',left='   + left;

    window.open(url, 'twitter', opts);

    return false;
  });

  $('#input-enable-show-download').click(function() {
    var status = $(this).is(':checked');
    if(status) {
      $(this).closest('label').siblings('div.download-pref-section').css('display','block');
    }
    else {
      $(this).closest('label').siblings('div.download-pref-section').css('display','none');
    }
  });

  $('#jQueryCityAutocomplete').keydown(function(event){
    if(event.keyCode == 13) {
      event.preventDefault();
    }

  });
});




