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

// Send message to facebook user
function facebook_send_message(element_id, name, profile_picture, site_address,from_id) {
  FB.ui(
  {
    method: 'send',
    to: element_id,
    name: 'Sign up for rvidi - Just like '+name+'!',
    link: 'http://rvidi.qwinixtech.com/users/new?from_id='+from_id,
    picture: profile_picture,
    description: 'Join '+name+' on rvidi.'
  },
  function(response) {
    if (response) {
      alert('Post was published.');
    } else {
      alert('Post was not published.');
    }
  }
  );
}



function facebook_send_message_to_invite(element_id, name, site_address, from_id, show_id) {
  FB.ui(
  {
    method: 'send',
    to: element_id,
    name: 'Sign up for rVidi - Just like '+name+'!',
    link: site_address + show_id +'?from_id='+from_id,
    description: 'Join '+name+' on rVidi.'
  },
  function(response) {
    if (response) {
      alert('Post was published.');
    } else {
      alert('Post was not published.');
    }
  }
  );
}


