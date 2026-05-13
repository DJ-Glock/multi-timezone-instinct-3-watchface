import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
using Toybox.Time;
using Toybox.Time.Gregorian;

var background = null;

class WatchFaceView extends WatchUi.WatchFace {

    function onTimer() {
        WatchUi.requestUpdate();
    }

    function initialize() {
        WatchFace.initialize();
    }

    function onLayout(dc as Dc) as Void {
        background = Toybox.WatchUi.loadResource(Rez.Drawables.bground);
    }

    function onUpdate(dc as Dc) as Void {
        // Setup
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.clear();

        // Background
        dc.drawBitmap(0, 0, background);

        // Main time
        Draw.drawMainTime(dc, 88, 60);

        // Additional locations
        drawAdditionalLocationTime(dc, "first", 88, 100);
        drawAdditionalLocationTime(dc, "second", 88, 120);
        drawAdditionalLocationTime(dc, "third", 88, 140);

        // Body battery
        Draw.drawBodyBattery(dc);

        // Steps
        var stepsCnt = ActivityMonitor.getInfo().steps;
        var steps = stepsCnt != null ? stepsCnt : 0;
        Draw.drawStepsCount(dc, steps);

        // Weather
        var currentConditions = Weather.getCurrentConditions();
        var temperature = currentConditions.temperature != null ? currentConditions.temperature : 0;
        var lowTemperature = currentConditions.lowTemperature != null ? currentConditions.lowTemperature : 0;
        var highTemperature = currentConditions.highTemperature != null ? currentConditions.highTemperature : 0;
        Draw.drawTemperature(dc, temperature, lowTemperature, highTemperature);

        // Date
        Draw.drawDate(dc);
    }

    function drawAdditionalLocationTime(dc as Dc, propertyPrefix as String, x as Number, y as Number) {
        var locationName = Application.Properties.getValue(Lang.format("$1$LocationName", [propertyPrefix])).toString();
        var locationLatitudeProp = Application.Properties.getValue(Lang.format("$1$LocationLatitude", [propertyPrefix])).toNumber();
        var locationLongtitudeProp = Application.Properties.getValue(Lang.format("$1$LocationLongtitude", [propertyPrefix])).toNumber();
        
        if (locationName.equals("UTC")) {
            Draw.drawUtcTime(dc, x, y);
        } else if (!locationName.equals("")) {
            var name = locationName.toString();
            var locationLatitude = locationLatitudeProp != null ? locationLatitudeProp : 0;
            var locationLongtitude = locationLongtitudeProp != null ? locationLongtitudeProp : 0;

            var locationPosition = new Position.Location({:latitude => locationLatitude, :longitude => locationLongtitude, :format => :degrees});
            Draw.drawTime(name, locationPosition, dc, x, y);
        }
    }
}
