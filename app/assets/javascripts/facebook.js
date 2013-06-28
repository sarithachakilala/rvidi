// Blocked to make consistancy for twitter and facebook login
// jQuery(function() {
//   $('body').prepend('<div id="fb-root"></div>');
//   return $.ajax({
//     url: "" + window.location.protocol + "//connect.facebook.net/en_US/all.js",
//     dataType: 'script',
//     cache: true
//   });
// });

function get_facebook_friends() {
  FB.api('/me/friends', {
    fields: 'name,id,picture'
  }, function(response) {
    jQuery.ajax({
      url: "/users/add_facebook_friends",
      data: JSON.stringify(response),
      type: 'POST',
      dataType: 'script',
      contentType: "application/json",
      error : function(xhr, status, response) {
        alert(response);
      }

    });
  });
}

function login() {
  FB.login(function(response) {
    if (response.authResponse) {
      // connected
      get_facebook_friends();

    } else {
      alert("Something wrong");
  }
  });
}
  
function invite_friends() {
  FB.getLoginStatus(function(response)
  {
    if(response.status === 'connected') {
      // connected
      login();
    } else if (response.status === 'not_authorized') {
      // not_authorized
      login();
    } else {
      // not_logged_in
      //setTimeout(login, 1000);
      login();
    }
  });

}

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
      }, {
        scope: 'email,user_likes'
      });
    });
    return $('#sign_out').click(function(e) {
      FB.getLoginStatus(function(response) {
        if (response.authResponse) {
          return FB.logout();
        }
      });
      return true;
    });
    
    // Used to send request added for future reference.
    function sendRequestToRecipients() {
      var user_ids = document.getElementsByName("user_ids")[0].value;
      FB.ui({
        method: 'apprequests',
        message: 'My Great Request',
        to: user_ids
      }, requestCallback);
    }
 
    function sendRequestViaMultiFriendSelector() {
      FB.ui({
        method: 'apprequests',
        message: 'My Great Request'
      }, requestCallback);
    }
       
    function requestCallback(response) {
    // Handle callback here
    }
  };
}