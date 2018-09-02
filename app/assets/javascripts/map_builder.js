$(function(){
  mapboxgl.accessToken = 'pk.eyJ1IjoiYWxleG5laWdoZXIiLCJhIjoiY2psZ3I1bTllMDF5ZjNwdDUydjQzMWJ1cCJ9.nG0jV5mQE65ySlh66w5faQ';
  var map = new mapboxgl.Map({
    container: 'map',
    center: [-122.4194, 37.7749],
    zoom: 10,
    style: 'mapbox://styles/mapbox/satellite-v9'
  });

  var draw = new MapboxDraw({
    displayControlsDefault: false,
    controls: {
      polygon: true,
    }  
  });

  map.addControl(new MapboxGeocoder({
      accessToken: mapboxgl.accessToken
  }));


  map.addControl(draw, 'top-left');

  map.on('draw.create', function (e) {
    //save to server?
    $('#shape-form').removeClass('d-none');
    $("#shape-form #shape_geo_info").val(JSON.stringify(e.features[0]));
  });

  map.on('load', function () {

    $.ajax({
      url:"/api/shapes",
      dataType: "json",
      success: function(data){
        add_shapes_to_map(data, map, 'parking_lot');
        add_shapes_to_map(data, map, 'parking_area');
        add_shapes_to_map(data, map, 'building');

        add_shapes_to_map(data, map, 'parking_space');

        // if (data.length > 0) {
        //   //recenter the map
        //   var bbox = turf.extent(data[0].geo_info.geometry);
        //   map.fitBounds(bbox, {
        //     padding: 50,
        //     duration: 0
        //   });
        // }
      },
      error: function (xhr) {
        alert(xhr.statusText)
      }
    });
  });

  map.on('click', 'parking_space', function(e){
    //find the element on the left side, highlight it

    id = e.features[0].properties.shape_id
    $('#'+id).addClass('list-group-item-success').siblings().removeClass('list-group-item-success');
  })

})//$(function)


function add_shapes_to_map(data, map, shape_type){
  features = data[shape_type]
  if (!features){
    return false;
  };
  geo_info = []
  for(let i=0, size=features.length; i<size; i++){
    features[i].geo_info.properties.shape_id = shape_type +"_" + features[i].id
    
    geo_info.push(features[i].geo_info)
  }
  map.addLayer({
    'id': shape_type,
    'type': 'fill',
    'source': {
        'type': 'geojson',
        "data": {
                  "type": "FeatureCollection",
                  "features": geo_info
                }
    },
    'layout': {},
    'paint': {
        'fill-color': map_shape_type_to_color(shape_type),
        'fill-opacity': 0.5
    }
  });
}



function map_shape_type_to_color(shape_type) {
  var hash  = {
                "parking_space": "red",
                "parking_area": 'green',
                "parking_lot": 'blue',
                "building": 'white',
              }
  return hash[shape_type]
}