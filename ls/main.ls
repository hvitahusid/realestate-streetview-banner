require.config do
    baseUrl: ''
    paths:
        jquery: 'js/lib/jquery-2.0.2'
        async: 'js/lib/plugins/async'
        isnet_to_wgs: 'js/lib/isnet93-to-wgs84'
        RealestateStreetView: 'ls/RealestateStreetView'

define('gmaps', ['async!http://maps.google.com/maps/api/js?v=3&sensor=false'], -> window.google.maps)

require ['RealestateStreetView'], (RealestateStreetView) ->
    window.app = new RealestateStreetView()
