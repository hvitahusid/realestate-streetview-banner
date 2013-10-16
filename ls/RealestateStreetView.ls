define 'RealestateStreetView', ['jquery', 'gmaps', 'isnet_to_wgs'], ($, gmaps, isnet_to_wgs) ->

    class RealestateStreetView
        mouseHover: false
        movementInterval: null
        panorama: null

        ->
            $('#pano').mouseenter ~>
                @mouseHover = true
            .mouseleave ~>
                @mouseHover = false

            @geocode decodeURIComponent(window.location.search.substr(1)), @renderPanorama

            return this

        geocode: (address, callback) ->
            $.getJSON 'proxy.php', {'q': address}, (res) ~>
                if res['map'].meta.count is 0
                    console.log 'zero results'
                    return
                c = res['map'].items[0].coordinates
                wgs = isnet_to_wgs(c.x, c.y)
                location = new gmaps.LatLng(wgs.lat, wgs.lng)

                return callback.call(this, location)

            return this

        getPanoramaLocation: (location, callback) ->
            streetView = new gmaps.StreetViewService()

            streetView.getPanoramaByLocation location, 50, (result, status) ~>
                if status is not 'OK'
                    console.log status
                    return

                return callback.call(this, result.location.latLng)

            return this

        computeHeading: (_from, _to) ->
            return gmaps.geometry.spherical.computeHeading(_from, _to)

        renderPanorama: (location) ->
            /*
            map = new gmaps.Map $('#map-canvas')[0], do
                center: location
                zoom: 14
                mapTypeId: gmaps.MapTypeId.ROADMAP
            */

            @getPanoramaLocation location, (pLocation) ->
                @heading = @computeHeading(pLocation, location)

                @panorama = new gmaps.StreetViewPanorama $('#pano')[0], do
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

                #map.setStreetView(panorama)

            return this

        init_movement: ->
            clearInterval(@movementInterval)

            @movementInterval = setInterval(~>
                if not @mouseHover
                    pov = @panorama.getPov()
                    pov.heading += 0.2
                    @panorama.setPov(pov)
            , 10)

        return this

    return RealestateStreetView
