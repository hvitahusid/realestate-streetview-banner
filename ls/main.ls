require.config do
    baseUrl: ''
    paths:
        #THREE: 'js/lib/three'
        #GSVPano: 'js/lib/GSVPano'
        #hyperlapse: 'js/lib/Hyperlapse'
        async: 'js/lib/plugins/async'
        #isnet_to_wgs: 'js/lib/isnet93-to-wgs84'
        RealestateStreetView: 'ls/RealestateStreetView'

define('gmaps', ['async!http://maps.google.com/maps/api/js?v=3&sensor=false'], -> window.google.maps)


require ['RealestateStreetView'], (RealestateStreetView) ->
    window.app = new RealestateStreetView()

    lineWidth = $('h1 .line').width();
    overlayHeight = $('#overlay').height();

    TimelineMax::orangeLine = (el, delay, stagger) ->
        if not stagger?
            stagger = 'line_width_stagger'

        width = $(el).width() + _line_margin

        @to($('h1 .line'), 0.5, {marginLeft: 0, delay: delay, width: width}, stagger)
        @to($('h1'), 0.5, {delay: delay, width: width}, stagger)

    TimelineMax::crossFade = (_from, _to, stagger) ->
        @to($(_from), 0.5, {opacity: 0, delay: 3}, stagger)
        @to($(_to), 0.5, {opacity: 1, delay: 3}, stagger)

    $('h1 .text, h2 .text').each ->
        $(this).height($(this).height())
        $(this).width($(this).width())

    h1_height = $('h1 .text').outerHeight()
    $('h1').height(h1_height)
    $('h2').height($('h2 .text').outerHeight())
    $('h2 .text').css do
        marginTop: $('h2 .text').outerHeight() * -1

    timeline = new TimelineMax({repeat: -1})
    timeline
        .orangeLine('h1 .text1', 0)
        .fromTo($('h1 .text1'), 0.5, {opacity: 1, marginBottom: -(h1_height)}, {marginBottom: 0}, 'text1in')
        .orangeLine('h1 .text2', 3, 'text1out')
        .crossFade('h1 .text1', 'h1 .text2', 'text1out')
        .orangeLine('h1 .text3', 3, 'text2out')
        .crossFade('h1 .text2', 'h1 .text3', 'text2out')
        .to($('#overlay'), 0.5, {height: overlayHeight + $('h2 .text').outerHeight()}, 'text3')
        .to($('h2 .text'), 0.5, {marginTop: 0}, 'text3')
        .to($('h2 .text'), 0.5, {marginTop: $('h2 .text').outerHeight() * -1, delay: 5}, 'text3out')
        .to($('#overlay'), 0.5, {height: overlayHeight, delay: 5}, 'text3out')
        .to($('h1 .text3'), 0.5, {marginBottom: $('h1 .text3').outerHeight() * -1, delay: 5}, 'text3out')
        .to($('h1 .line'), 0.5, {marginLeft: -(lineWidth)})
