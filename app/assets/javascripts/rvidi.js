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