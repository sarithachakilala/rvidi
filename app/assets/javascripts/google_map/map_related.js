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
  
  location_autocomplete: function(element, lat, lng) {

    var input = document.getElementById(element);
    var autocomplete = new google.maps.places.Autocomplete(input);

    autocomplete.bindTo('bounds', Google_Map.map);
    google.maps.event.addListener(autocomplete, 'place_changed', function() {
      var place = autocomplete.getPlace();
      console.log(place);
      if(lat.length > 0 && lng.length > 0) {
        $(lat).val(place.geometry.location.lat());
        $(lng).val(place.geometry.location.lng());
        if($('.jQueryCuriousName').length > 0) {
          $('.jQueryCuriousName').val(input.value);
        }
      }

    });

  }
  
}