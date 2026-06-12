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
        setLayout( Rez.Layouts.MainLayout ( dc ) );
        background = Toybox.WatchUi.loadResource(Rez.Drawables.bground);
    }

    function onUpdate(dc as Dc) as Void {
        // Setup
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.clear();

        // Background
        dc.drawBitmap(0, 0, background);

        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);

        // Main time
        var mainTimeLabel = View.findDrawableById("timeLabel") as Text;
        Draw.drawMainTime(mainTimeLabel);
    
        // Additional locations
        drawAdditionalLocationTime("first");
        drawAdditionalLocationTime("second");
        drawAdditionalLocationTime("third");
        
        // Battery info
        var batteryType = Application.Properties.getValue("batteryType").toNumber();
        var batteryLabel = View.findDrawableById("batteryLabel") as Text;
        if (batteryType.equals(0)) {
            Draw.drawBodyBattery(batteryLabel);
        } else {
            Draw.drawDeviceBattery(batteryLabel);
        }

        // Steps
        var stepsCnt = ActivityMonitor.getInfo().steps;
        var steps = stepsCnt != null ? stepsCnt : 0;
        var stepsLabel = View.findDrawableById("stepsLabel") as Text;
        Draw.drawStepsCount(stepsLabel, steps);

        // Weather
        var weatherLabel = View.findDrawableById("weatherLabel") as Text;
        var temperatureLabel = View.findDrawableById("temperatureLabel") as Text;
        var currentConditions = Weather.getCurrentConditions();

        if (currentConditions == null) {
            Draw.drawWeather(weatherLabel, "No forecast");
            Draw.drawWeather(temperatureLabel, "");
        } else {
            var weatherFormat = Application.Properties.getValue("weatherFormat").toNumber();
            if (weatherFormat.equals(0)) {
                var condition = WeatherParser.parseWeatherCondition(currentConditions.condition);
                var temperature = currentConditions.temperature != null ? currentConditions.temperature : 0;
                var temperatureText = Lang.format("$1$°", [temperature.format("%2d")]);
                var weatherText = Lang.format("$1$ $2$", [condition, temperatureText]);

                // Split long string
                if (weatherText.length() > 14) {
                    Draw.drawWeather(weatherLabel, condition);
                    Draw.drawWeather(temperatureLabel, temperatureText);
                } else {
                    Draw.drawWeather(weatherLabel, weatherText);
                    Draw.drawWeather(temperatureLabel, "");
                }
            } else {
                var temperature = currentConditions.temperature != null ? currentConditions.temperature : 0;
                var lowTemperature = currentConditions.lowTemperature != null ? currentConditions.lowTemperature : 0;
                var highTemperature = currentConditions.highTemperature != null ? currentConditions.highTemperature : 0;
                var weatherText = Lang.format(
                    "$1$°, $2$/$3$°", 
                    [temperature.format("%2d"), lowTemperature.format("%2d"), highTemperature.format("%2d")]
                );
                Draw.drawWeather(weatherLabel, weatherText);
                Draw.drawWeather(temperatureLabel, "");
            }
        }

        // Date
        var dateLabel = View.findDrawableById("dateLabel") as Text;
        var dayLabel = View.findDrawableById("dayLabel") as Text;
        Draw.drawDate(dateLabel, dayLabel);
    }

    function drawAdditionalLocationTime(propertyPrefix as String) {
        var locationName = Application.Properties.getValue(Lang.format("$1$LocationName", [propertyPrefix])).toString();
        var locationLatitudeProp = Application.Properties.getValue(Lang.format("$1$LocationLatitude", [propertyPrefix])).toNumber();
        var locationLongtitudeProp = Application.Properties.getValue(Lang.format("$1$LocationLongtitude", [propertyPrefix])).toNumber();

        var labelName = Lang.format("$1$TimeZoneLabel", [propertyPrefix]);
        var label = View.findDrawableById(labelName) as Text;
        
        if (locationName.equals("UTC")) {
            Draw.drawUtcTime(label);
        } else if (!locationName.equals("")) {
            var name = locationName.toString();
            var locationLatitude = locationLatitudeProp != null ? locationLatitudeProp : 0;
            var locationLongtitude = locationLongtitudeProp != null ? locationLongtitudeProp : 0;

            var locationPosition = new Position.Location({:latitude => locationLatitude, :longitude => locationLongtitude, :format => :degrees});
            Draw.drawTime(name, locationPosition, label);
        } else {
            Draw.drawEmptyTime(label);
        }
    }
}
