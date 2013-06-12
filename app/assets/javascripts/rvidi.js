jQuery(document).ready(function(){

});

// Send message to facebook user
function facebook_send_message(element_id, name, profile_picture) {
  FB.ui(
  {
    method: 'send',
    to: element_id,
    name: 'Sign up for rvidi - Just like '+name+'!',
    link: 'http://rvidi.qwinixtech.com',
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