/////////////API and base map import
var graymap = L.tileLayer("https://api.tiles.mapbox.com/v4/{id}/{z}/{x}/{y}.png?access_token=pk.eyJ1Ijoic2hlcmlmZmxvYm8iLCJhIjoiY2pzMmY3c2hlMDJjMTQzcnVwNDFlZ20xNyJ9.0hsoR5sNub1jvg_jaPH_0g", {
  attribution: "Map data &copy; <a href='https://www.openstreetmap.org/'>OpenStreetMap</a> contributors, <a href='https://creativecommons.org/licenses/by-sa/2.0/'>CC-BY-SA</a>, Imagery © <a href='https://www.mapbox.com/'>Mapbox</a>",
  maxZoom: 10,
  id: "mapbox.streets"
});

//create map object
var map = L.map("mapid", {
  center: [
    40.7, -94.5
  ],
  zoom: 3
});

//append map object to HTML div
graymap.addTo(map);

//D3 earthquake data import
d3.json("https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_month.geojson", function(data) {

  // Function to create color and radius properties
  function styleInfo(feature) {
    return {
      opacity: 0.5,
      fillOpacity: 0.5,
      fillColor: quakeColor(feature.properties.mag),
      color: "#000000",
      radius: quakeRadius(feature.properties.mag),
      stroke: true,
      weight: 0.25
    };
  }

  // Setting marker Color based on magnitude
  function quakeColor(magnitude) {
    switch (true) {
    case magnitude > 5:
      return "#8B0000";
    case magnitude > 4:
      return "#FF6347";
    case magnitude > 3:
      return "#CCCC00";
    case magnitude > 2:
      return "#ADFF2F";
    case magnitude > 1:
      return "#98ee00";
    default:
      return "#00FF00";
    }
  }

  // function to determine marker radius based on magnitude
  function quakeRadius(magnitude) {
    //control for small magnitude earthquakes
    if (magnitude <= 0.5) {
      return 1;
    }

    return magnitude * 3.5;
  }


  L.geoJson(data, {
    //creating coordinates for marker based on USGS data
    pointToLayer: function(feature, latlon) {
      return L.circleMarker(latlon);
    },
    
    style: styleInfo,
    // info pop-up
    onEachFeature: function(feature, layer) {
      layer.bindPopup("Magnitude: " + feature.properties.mag + "<br>Location: " + feature.properties.place + "<br>Tsunami: " + feature.properties.tsunami);
    }
  }).addTo(map);

  // Here we create a legend control object.
  var legend = L.control({
    position: "bottomright"
  });

  // Then add all the details for the legend
  legend.onAdd = function() {
    var div = L.DomUtil.create("div", "info legend");

    var grades = [0, 1, 2, 3, 4, 5];
    var colors = [
      "#00FF00",
      "#98ee00",
      "#ADFF2F",
      "#CCCC00",
      "#FF6347",
      "#8B0000"
    ];

    // Creating each row in the legend box
    for (var i = 0; i < grades.length; i++) {
      div.innerHTML +=
        "<i style='background: " + colors[i] + "'></i> " +
        grades[i] + (grades[i + 1] ? "&ndash;" + grades[i + 1] + "<br>" : "+");
    }
    return div;
  };

  //append legend to the map
  legend.addTo(map);
});
