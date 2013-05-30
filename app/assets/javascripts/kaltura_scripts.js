$(document).ready(function(){

});

function jsCallbackReady(objectId){
  window.kdp = document.getElementById(objectId);
  // kdp.setKDPAttribute("configProxy.flashvars","autoPlay","true")
}

function loadKalturaPlayer(PARTNER_ID, ENTRY_ID, TARGET_DIV_ID){
  var UICONF_ID = '14018252'
  kWidget.embed({
    'targetId': TARGET_DIV_ID,
    'wid': '_'+PARTNER_ID,
    'uiconf_id' : UICONF_ID,
    'entry_id' : ENTRY_ID,
    'flashvars':{ // flashvars allows you to set runtime uiVar configuration overrides. 
        'autoPlay': true,
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
