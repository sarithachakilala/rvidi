// Send message to facebook user
function facebook_send_message(element_id, name, profile_picture, site_address,from_id) {
  FB.ui(
  {
    method: 'send',
    to: element_id,
    name: 'Sign up for rvidi - Just like '+name+'!',
    link: 'http://rvidi.qwinixtech.com/users/new?from_id='+from_id,
    picture: 'http://rvidi.qwinixtech.com/assets/logo/rvidifb.png',
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
    link: "http://rvidi.qwinixtech.com/" + show_id +'?from_id='+from_id,
    description: 'Join '+name+' on rVidi.',
    picture: "http://rvidi.qwinixtech.com/assets/logo/rvidifb.png"
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


function get_facebook_friends() {
  var csrfToken = $('meta[name="csrf-token"]').attr('content');
  FB.api('/me/friends', {
    fields: 'name,id,picture'
  }, function(response) {
    jQuery.ajax({
      url: "/users/add_facebook_friends",
      data: JSON.stringify(response),
      type: 'POST',
      headers: {
        'X-CSRF-Token': csrfToken
      },
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
      get_facebook_friends();
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