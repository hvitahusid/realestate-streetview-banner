class RealestateStreetView
    mouseHover: false
    movementInterval: null
    panorama: null
    hyperlapse: null

    ->
        $('#pano').mouseenter(~> @mouseHover = true).mouseleave(~> @mouseHover = false)

        addr_override = decodeURIComponent(window.location.search.substr(1))
        if addr_override
            console.log 'Address url override. Using google geocoder...'
            @google_geocode addr_override, @renderPanorama
        else if _site is 'visir'
            if AB?
                if AB is 'A'
                    $('#overlay h2 .text').html('Reiknaðu dæmið &rang;');
                else if AB is 'B'
                    $('#overlay h2 .text').html('Fáðu ráðgjöf &nbsp;&rang;');

            address = $('.b-house-adress h2', top.document).text()
            location = @visir_geocode!
            if location
                @renderPanorama location
                console.log 'Location found in top.document, let\'s rock! ;D'
            else
                console.log 'No location found in top.document.'
                if address
                    console.log 'Found address. Using google geocoder...'
                    @google_geocode address, @renderPanorama
                else
                    console.log 'No address found. Using placeholder'
        else if _site is 'mbl'
            rdata = top.realestate_data()
            @ja_geocode rdata.address, @render360

        return this

    ja_geocode: (address, callback) ->
        self = this
        $.ajax do
            url: 'https://apache.hvitahusid.is/arion/realestate-streetview/proxy.php'
            jsonp: 'callback'
            dataType: 'jsonp'
            data: {q: decodeURIComponent(address)}
            success: (data) ->
                if callback?
                    callback.call(self, data)
                else
                    console.log data

    # Evaluate this code from top window:
    # $(function() { initialize_estate(64.0604166666667,-21.9529666666667,16); });
    # returns: [64.0604166666667, -21.9529666666667]
    visir_geocode: ->
        var location, $
        initialize_estate = (lat, lng) ->
            if lat? and lng?
                location := new google.maps.LatLng(lat, lng)
            else
                location := null
        $ = (cb) -> cb()
        jQuery('.google_map script', top.document).html() |> eval
        return location

    google_geocode: (address, callback) ->
        geocoder = new google.maps.Geocoder!

        return geocoder.geocode {'address': address}, (results, status) ~>
            if status !== google.maps.GeocoderStatus.OK
                console.log status
                return

            if callback?
                return callback.call(this, results[0].geometry.location)

    getPanoramaLocation: (location, callback) ->
        streetView = new google.maps.StreetViewService!

        streetView.getPanoramaByLocation location, 50, (result, status) ~>
            if status is not 'OK'
                console.log status
                return

            return callback.call(this, result.location.latLng)

        return this

    computeHeading: (_from, _to) ->
        return google.maps.geometry.spherical.computeHeading(_from, _to)

    build360url: (data) ->
        'http://ja.is/kort/?' + $.param do
            q: data.address
            x: data.x
            y: data.y
            z: 10
            type: 'map'
            ja360: 1
            jh: 'auto'

    render360: (data) ->
        $iframe = $ '<iframe>', do
            src: @build360url(data)
            width: '100%'
            height: '100%'
            scrolling: 'no'
            frameborder: 0
            marginwidth: 0
            marginheight: 0
        .css do
            width: '100%'
            height: '100%'

        $('#pano').html($iframe)

        setTimeout ->
            $('#loader').fadeOut(200)
        , 2000

    renderPanorama: (location) ->
        @getPanoramaLocation location, (pLocation) ->
            @heading = @computeHeading(pLocation, location)

            @panorama = new google.maps.StreetViewPanorama $('#pano')[0], do
                position: location
                pov:
                    heading: @heading
                    pitch: 0
                addressControl: false
                linksControl: false
                panControl: false
                zoomControl: false
                enableCloseButton: false
            @init_movement()
            setTimeout ->
                $('#loader').fadeOut(200)
            , 2000

        return this

    renderHyperlapse: (start_location, end_location) ->
        @hyperlapse = new Hyperlapse $('#pano')[0], do
            lookat: end_location
            zoom: 1
            use_lookat: true
            elevation: 0
            millis: 100
            width: 310
            height: 400
            max_points: 400
            distance_between_points: 0.2

        @hyperlapse.onError = (e) ~>
            console.log(e)

        @hyperlapse.onRouteComplete = (e) ~>
            @hyperlapse.load!

        @hyperlapse.onLoadComplete = (e) ~>
            @hyperlapse.play!

        # Google Maps API stuff here...
        directions_service = new google.maps.DirectionsService!

        route =
            request:
                origin: start_location
                destination: end_location
                travelMode: google.maps.DirectionsTravelMode.DRIVING

        directions_service.route route.request, (res, status) ~>
            if status === google.maps.DirectionsStatus.OK
                @hyperlapse.generate({route: res})
            else
                console.log(status);

        return this

    init_movement: ->
        clearInterval(@movementInterval)

        @movementInterval = setInterval(~>
            if not @mouseHover
                pov = @panorama.getPov!
                pov.heading += 0.2
                @panorama.setPov(pov)
        , 10)

    return this
