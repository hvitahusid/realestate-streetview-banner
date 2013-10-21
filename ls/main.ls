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

    lineWidth = $('h1 .line').width();
    overlayHeight = $('#overlay').height();

    TimelineMax::orangeLine = ($el, delay, stagger) ->
        if not stagger?
            stagger = 'line_width_stagger'

        margin = 22

        width = $el.width() + margin

        @to($('h1 .line'), 0.5, {marginLeft: 0, delay: delay, width: width}, stagger)
        @to($('h1'), 0.5, {delay: delay, width: width}, stagger)

    TimelineMax::crossFade = (_from, _to, stagger) ->
        @to($(_from), 0.5, {opacity: 0, delay: 3}, stagger)
        @to($(_to), 0.5, {opacity: 1, delay: 3}, stagger)

    timeline = new TimelineMax({repeat: -1})
    timeline
        .orangeLine($('h1 .text1'), 0)
        .fromTo($('h1 .text1'), 0.5, {opacity: 1, marginBottom: '-26px'}, {marginBottom: 0}, 'text1in')
        .orangeLine($('h1 .text2'), 3, 'text1out')
        .crossFade('h1 .text1', 'h1 .text2', 'text1out')
        .orangeLine($('h1 .text3'), 3, 'text2out')
        .crossFade('h1 .text2', 'h1 .text3', 'text2out')
        .to($('#overlay'), 0.5, {height: overlayHeight + 26}, 'text3')
        .to($('h2 .text'), 0.5, {marginTop: 0}, 'text3')
        .to($('h2 .text'), 0.5, {marginTop: '-26px', delay: 5}, 'text3out')
        .to($('#overlay'), 0.5, {height: overlayHeight, delay: 5}, 'text3out')
        .to($('h1 .text3'), 0.5, {marginBottom: '-26px', delay: 5}, 'text3out')
        .to($('h1 .line'), 0.5, {marginLeft: -(lineWidth)})
