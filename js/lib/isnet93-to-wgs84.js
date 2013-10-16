define(function () {
    'use strict';

    return function(x, y) {
        var a = 6378137.0,
            f = 1/298.257222101,
            lat1 = 64.25,
            lat2 = 65.75,
            latc = 65.00,
            lonc = 19.00,
            eps = 0.00000000001;
        
        var rho = 45/Math.atan2(1.0, 1.0);
        var e = Math.sqrt(f * (2 - f));

        var fx = function(p) {
            return a * Math.cos(p / rho) / Math.sqrt(1 - Math.pow(e * Math.sin(p / rho), 2));
        };

        var f1 = function(p) {
            return Math.log((1 - p) / (1 + p));
        };

        var f2 = function(p) {
            return f1(p) - e * f1(e * p);
        };

        var f3 = function(p) {
            return pol1 * Math.exp((f2(Math.sin(p / rho)) - f2sin1) * sint / 2);
        };

        var dum = f2(Math.sin(lat1 / rho)) - f2(Math.sin(lat2 / rho));
        var sint = 2 * (Math.log(fx(lat1)) - Math.log(fx(lat2))) / dum;
     
        var f2sin1 = f2(Math.sin(lat1 / rho));
        var pol1 = fx(lat1) / sint;
        var polc = f3(latc) + 500000.0;

        var peq = a * Math.cos(latc / rho) / (sint * Math.exp(sint * Math.log((45 - latc / 2) / rho)));

        var pol = Math.sqrt(Math.pow(x - 500000,2) + Math.pow(polc - y, 2));
        
        var lat = 90 - 2 * rho * Math.atan(Math.exp( Math.log( pol / peq ) / sint ));
        var lon = 0;

        var fact = rho * Math.cos(lat / rho) / sint / pol;

        var delta = 1.0;
        while(Math.abs(delta) > eps) {
            delta = (f3(lat) - pol) * fact;
            lat += delta;
        }
     
        lon = -(lonc + rho * Math.atan((500000 - x) / (polc - y)) / sint);

        return {
            'lat': lat.toFixed(10),
            'lng': lon.toFixed(10)
        };
    };
});