onICHostReady = function(version) {

   if ( version != 1.0 ) {
      alert('Invalid API version');
   }

   gICAPI.onProperty = function(properties) {
      var ps = JSON.parse(properties);
      if (ps.url!="") {
        setTimeout( function () {
          downloadURL(ps.url);
        }, 0);
      }
   }

}

var debug_js
var UK4js
var latlng
var latlngString

function initMap() { 

  debug_js = ""
  UK4js = {lat: 51.4557992, lng: 0.2491976}; 
  latlang = new google.maps.LatLng( UK4js );

  var map = new google.maps.Map(
    document.getElementById('map_canvas'), {
      zoom: 12,
      center: UK4js 
  });
  var marker = new google.maps.Marker({
    position: UK4js,
    map: map
  }); 

  google.maps.event.addListener(map, 'click', function(event) {
    mapClicked( event.latLng );
  });
}
      
function mapClicked(where) {
	debug_js = debug_js + "mapClicked:"+where+"<br />";
  latlng = where
	//document.getElementById("debug").innerHTML = debug_js;
  
  document.getElementById("test").innerHTML = returnlatlng();
  gICAPI.Action('mapclicked');
  
}

function returnlatlng(run) {
  latlngString = JSON.stringify(latlng);
  console.log(latlngString);
  return latlngString
}

function echostring(str){
  return str
}