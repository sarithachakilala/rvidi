// Google Map code
var zoom = 10;
var geocoder = new google.maps.Geocoder();

var Google_Map = {

  map: '',
  default_marker: null,
  markers: new Array(),
  gm_ids: new Array(),
  lat_lng_obj: '',

  init: function(lat, lng) {
    var latlng = new google.maps.LatLng(lat, lng);
    var options = {
      zoom: zoom,
      center: latlng,
      mapTypeId: google.maps.MapTypeId.ROADMAP
    }

    Google_Map.map = new google.maps.Map(document.getElementById("map-container"), options);

    this.infowindow = new google.maps.InfoWindow({
      content: "Holding..."
    });

  },
  
  location_autocomplete: function(element) {

    var input = document.getElementById(element);
    var autocomplete = new google.maps.places.Autocomplete(input);
    autocomplete.bindTo('bounds', Google_Map.map);
    google.maps.event.addListener(autocomplete, 'place_changed', function() {
      google.setOnLoadCallback(Location.onLoad(element));
    });

  }
  
}

//Location Search Code

Location = {
  localSearch: '',
  street_address: '',
  city: '',
  state: '',
  country: '',
  full_address: '',

  onLoad: function(element) {
    var input = document.getElementById(element);
    Location.localSearch = new google.search.LocalSearch();

    Location.localSearch.setSearchCompleteCallback(this,
      Location.searchComplete, null);

    // Specify search quer(ies)
    Location.localSearch.execute(input.value);
  },

  // Get location address.
  searchComplete: function() {
    try {
      if(Location.localSearch.results)
      {
        for (var i = 0; i <= 0 ; i++) {
          Location.street_address = Location.localSearch.results[i].streetAddress;
          Location.city = Location.localSearch.results[i].city;
          Location.state = Location.localSearch.results[i].region;
          Location.full_address = Location.street_address + ', ' + Location.city + ', ' + Location.state;
        }

        //This api returns WOEID of the location
        if( navigator.userAgent.match(/msie/i) && window.XDomainRequest) {
          xdr = new XDomainRequest();
          xdr.onload = function() {
            Location.populate_location_attributes(xdr.responseText);
          }
          xdr.onerror = function() {
            alert("Pelase try again later");
          }
          xdr.open("GET", "//query.yahooapis.com/v1/public/yql?q=select%20*%20from%20geo.placefinder%20where%20text%3D%22"+encodeURIComponent(Location.full_address)+"%22&format=json");
          xdr.send();

        }
        else {
          console.log("entering");
          var url = "//query.yahooapis.com/v1/public/yql?q=select%20*%20from%20geo.placefinder%20where%20text%3D%22"+encodeURIComponent(Location.full_address)+"%22&format=json"
          console.log(url);
          jQuery.ajax({
            type: 'GET',
            url: "//query.yahooapis.com/v1/public/yql?q=select%20*%20from%20geo.placefinder%20where%20text%3D%22"+encodeURIComponent(Location.full_address)+"%22&format=json",
            success: function(result){
              Location.populate_location_attributes(result);
            },
            error: function() {
              alert("Please try again");
            }
          });
        }
      }
    }
    catch(err) {
      console.log(err);
    }
    
  },

  populate_location_attributes : function(result) {
    if(jQuery.type(result) === 'string') {
      result = jQuery.parseJSON(result);
    }

    if(jQuery.isArray(result['query']['results']['Result'])) {

      if(result['query']['results']['Result'][0]['city'] != null) {
        Location.city = result['query']['results']['Result'][0]['city']
      }

      if(result['query']['results']['Result'][0]['state'] != null) {
        Location.state = result['query']['results']['Result'][0]['state']
      }

      if(result['query']['results']['Result'][0]['country'] != null) {
        Location.country = result['query']['results']['Result'][0]['country']
      }
      
    }
    else {
      if(result['query']['results']['Result']['city'] != null) {
        Location.city = result['query']['results']['Result']['city']
      }

      if(result['query']['results']['Result']['state'] != null) {
        Location.state = result['query']['results']['Result']['state']
      }

      if(result['query']['results']['Result']['country'] != null) {
        Location.country = result['query']['results']['Result']['country']
      }
    }

    $('#user_city').val(Location.city);
    $('#user_state').val(Location.state);
    $('#user_country').val(Location.country);
  }

}

