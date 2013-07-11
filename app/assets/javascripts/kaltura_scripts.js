function jsCallbackReady(objectId){
  window.kdp = document.getElementById(objectId);
  // kdp.setKDPAttribute("configProxy.flashvars","autoPlay","true")
}

function loadKalturaPlayerWithoutPlaylist(PARTNER_ID, ENTRY_ID, TARGET_DIV_ID, autoPlay){
  var UICONF_ID = '6709462'
  kWidget.embed({
    'targetId': TARGET_DIV_ID,
    'wid': '_'+PARTNER_ID,
    'uiconf_id' : UICONF_ID,
    'entry_id' : ENTRY_ID,
    // 'forceMobileHTML5': true,
    // 'Kaltura.LeadWithHTML5': true,
    'flashvars':{ // flashvars allows you to set runtime uiVar configuration overrides. 
        'autoPlay': autoPlay,
        'loop': false
    },
    'params':{ // params allows you to set flash embed params such as wmode, allowFullScreen etc
      'wmode': 'transparent'
    },
    readyCallback: function( playerId ){
      // console.log( 'Player:' + playerId + ' is ready '); 
    }
  });
}

function loadKalturaPlayer(PARTNER_ID, ENTRY_ID, TARGET_DIV_ID, autoPlay, playlist_id){
  var UICONF_ID = '6709461'
  kWidget.embed({
    'targetId': TARGET_DIV_ID,
    'wid': '_'+PARTNER_ID,
    'uiconf_id' : UICONF_ID,
    // 'forceMobileHTML5': true,
    // 'Kaltura.LeadWithHTML5': true,
    'flashvars':{ // flashvars allows you to set runtime uiVar configuration overrides.
        'autoPlay': autoPlay,
        'loop': false,
        "playlistAPI.kpl0Id": playlist_id
    },
    'params':{ // params allows you to set flash embed params such as wmode, allowFullScreen etc
      'wmode': 'transparent'
    },
    readyCallback: function( playerId ){
      // console.log( 'Player:' + playerId + ' is ready ');
    }
  });
}



