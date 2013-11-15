// Generated by LiveScript 1.2.0
var RealestateStreetView;
RealestateStreetView = (function(){
  RealestateStreetView.displayName = 'RealestateStreetView';
  var prototype = RealestateStreetView.prototype, constructor = RealestateStreetView;
  prototype.mouseHover = false;
  prototype.movementInterval = null;
  prototype.panorama = null;
  prototype.hyperlapse = null;
  function RealestateStreetView(){
    var addr_override, address, location, this$ = this;
    $('#pano').mouseenter(function(){
      return this$.mouseHover = true;
    }).mouseleave(function(){
      return this$.mouseHover = false;
    });
    addr_override = decodeURIComponent(window.location.search.substr(1));
    if (addr_override) {
      console.log('Address url override. Using google geocoder...');
      this.google_geocode(addr_override, this.renderPanorama);
    } else if (_site === 'visir') {
      if (typeof AB != 'undefined' && AB !== null) {
        if (AB === 'A') {
          $('#overlay h2 .text').html('Reiknaðu dæmið &rang;');
        } else if (AB === 'B') {
          $('#overlay h2 .text').html('Fáðu ráðgjöf &rang;');
        }
      }
      address = $('.b-house-adress h2', top.document).text();
      location = this.visir_geocode();
      if (location) {
        this.renderPanorama(location);
        console.log('Location found in top.document, let\'s rock! ;D');
      } else {
        console.log('No location found in top.document.');
        if (address) {
          console.log('Found address. Using google geocoder...');
          this.google_geocode(address, this.renderPanorama);
        } else {
          console.log('No address found. TODO: Create placeholder banner');
        }
      }
    }
    return this;
  }
  prototype.visir_geocode = function(){
    var location, $, initialize_estate;
    initialize_estate = function(lat, lng){
      if (lat != null && lng != null) {
        return location = new google.maps.LatLng(lat, lng);
      } else {
        return location = null;
      }
    };
    $ = function(cb){
      return cb();
    };
    eval(jQuery('.google_map script', top.document).html());
    return location;
  };
  prototype.google_geocode = function(address, callback){
    var geocoder, this$ = this;
    geocoder = new google.maps.Geocoder();
    return geocoder.geocode({
      'address': address
    }, function(results, status){
      if (!deepEq$(status, google.maps.GeocoderStatus.OK, '===')) {
        console.log(status);
        return;
      }
      if (callback != null) {
        return callback.call(this$, results[0].geometry.location);
      }
    });
  };
  prototype.getPanoramaLocation = function(location, callback){
    var streetView, this$ = this;
    streetView = new google.maps.StreetViewService();
    streetView.getPanoramaByLocation(location, 50, function(result, status){
      if (status !== 'OK') {
        console.log(status);
        return;
      }
      return callback.call(this$, result.location.latLng);
    });
    return this;
  };
  prototype.computeHeading = function(_from, _to){
    return google.maps.geometry.spherical.computeHeading(_from, _to);
  };
  prototype.renderPanorama = function(location){
    this.getPanoramaLocation(location, function(pLocation){
      this.heading = this.computeHeading(pLocation, location);
      this.panorama = new google.maps.StreetViewPanorama($('#pano')[0], {
        position: location,
        pov: {
          heading: this.heading,
          pitch: 0
        },
        addressControl: false,
        linksControl: false,
        panControl: false,
        zoomControl: false,
        enableCloseButton: false
      });
      this.init_movement();
      return setTimeout(function(){
        return $('#loader').fadeOut(200);
      }, 2000);
    });
    return this;
  };
  prototype.renderHyperlapse = function(start_location, end_location){
    var directions_service, route, this$ = this;
    this.hyperlapse = new Hyperlapse($('#pano')[0], {
      lookat: end_location,
      zoom: 1,
      use_lookat: true,
      elevation: 0,
      millis: 100,
      width: 310,
      height: 400,
      max_points: 400,
      distance_between_points: 0.2
    });
    this.hyperlapse.onError = function(e){
      return console.log(e);
    };
    this.hyperlapse.onRouteComplete = function(e){
      return this$.hyperlapse.load();
    };
    this.hyperlapse.onLoadComplete = function(e){
      return this$.hyperlapse.play();
    };
    directions_service = new google.maps.DirectionsService();
    route = {
      request: {
        origin: start_location,
        destination: end_location,
        travelMode: google.maps.DirectionsTravelMode.DRIVING
      }
    };
    directions_service.route(route.request, function(res, status){
      if (deepEq$(status, google.maps.DirectionsStatus.OK, '===')) {
        return this$.hyperlapse.generate({
          route: res
        });
      } else {
        return console.log(status);
      }
    });
    return this;
  };
  prototype.init_movement = function(){
    var this$ = this;
    clearInterval(this.movementInterval);
    return this.movementInterval = setInterval(function(){
      var pov;
      if (!this$.mouseHover) {
        pov = this$.panorama.getPov();
        pov.heading += 0.2;
        return this$.panorama.setPov(pov);
      }
    }, 10);
  };
  return RealestateStreetView;
  return RealestateStreetView;
}());
function deepEq$(x, y, type){
  var toString = {}.toString, hasOwnProperty = {}.hasOwnProperty,
      has = function (obj, key) { return hasOwnProperty.call(obj, key); };
  var first = true;
  return eq(x, y, []);
  function eq(a, b, stack) {
    var className, length, size, result, alength, blength, r, key, ref, sizeB;
    if (a == null || b == null) { return a === b; }
    if (a.__placeholder__ || b.__placeholder__) { return true; }
    if (a === b) { return a !== 0 || 1 / a == 1 / b; }
    className = toString.call(a);
    if (toString.call(b) != className) { return false; }
    switch (className) {
      case '[object String]': return a == String(b);
      case '[object Number]':
        return a != +a ? b != +b : (a == 0 ? 1 / a == 1 / b : a == +b);
      case '[object Date]':
      case '[object Boolean]':
        return +a == +b;
      case '[object RegExp]':
        return a.source == b.source &&
               a.global == b.global &&
               a.multiline == b.multiline &&
               a.ignoreCase == b.ignoreCase;
    }
    if (typeof a != 'object' || typeof b != 'object') { return false; }
    length = stack.length;
    while (length--) { if (stack[length] == a) { return true; } }
    stack.push(a);
    size = 0;
    result = true;
    if (className == '[object Array]') {
      alength = a.length;
      blength = b.length;
      if (first) { 
        switch (type) {
        case '===': result = alength === blength; break;
        case '<==': result = alength <= blength; break;
        case '<<=': result = alength < blength; break;
        }
        size = alength;
        first = false;
      } else {
        result = alength === blength;
        size = alength;
      }
      if (result) {
        while (size--) {
          if (!(result = size in a == size in b && eq(a[size], b[size], stack))){ break; }
        }
      }
    } else {
      if ('constructor' in a != 'constructor' in b || a.constructor != b.constructor) {
        return false;
      }
      for (key in a) {
        if (has(a, key)) {
          size++;
          if (!(result = has(b, key) && eq(a[key], b[key], stack))) { break; }
        }
      }
      if (result) {
        sizeB = 0;
        for (key in b) {
          if (has(b, key)) { ++sizeB; }
        }
        if (first) {
          if (type === '<<=') {
            result = size < sizeB;
          } else if (type === '<==') {
            result = size <= sizeB
          } else {
            result = size === sizeB;
          }
        } else {
          first = false;
          result = size === sizeB;
        }
      }
    }
    stack.pop();
    return result;
  }
}