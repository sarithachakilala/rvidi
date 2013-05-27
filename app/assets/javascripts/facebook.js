// Blocked to make consistancy for twitter and facebook login
// jQuery(function() {
//   $('body').prepend('<div id="fb-root"></div>');
//   return $.ajax({
//     url: "" + window.location.protocol + "//connect.facebook.net/en_US/all.js",
//     dataType: 'script',
//     cache: true
//   });
// });

function facebookLogin(facebook_app_id){
  window.fbAsyncInit = function() {
    FB.init({
      appId: facebook_app_id,
      cookie: true
    });
    $('#sign_in').click(function(e) {
      e.preventDefault();
      return FB.login(function(response) {
        if (response.authResponse) {
          return window.location = '/auth/facebook/callback';
        }
      }, {scope: 'email,user_likes'});
    });
    return $('#sign_out').click(function(e) {
      FB.getLoginStatus(function(response) {
        if (response.authResponse) {
          return FB.logout();
        }
      });
      return true;
    });
    function sendRequestToRecipients() {
        var user_ids = document.getElementsByName("user_ids")[0].value;
        FB.ui({method: 'apprequests',
          message: 'My Great Request',
          to: user_ids, 
        }, requestCallback);
      }
 
      function sendRequestViaMultiFriendSelector() {
        FB.ui({method: 'apprequests',
          message: 'My Great Request'
        }, requestCallback);
      }
       
      function requestCallback(response) {
        // Handle callback here
      }
  };
}