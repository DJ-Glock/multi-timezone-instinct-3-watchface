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

    function onUpdate(deviceContext as Dc) as Void {
        // Setup
        deviceContext.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        deviceContext.clear();

        // Background
        deviceContext.drawBitmap(0, 0, background);

        // Main time
        drawMainTime(deviceContext, 88, 60);

        // New York
        var nyPosition = new Position.Location({:latitude => 40.7, :longitude => -74.0, :format => :degrees});
        drawTime("New York", nyPosition, deviceContext, 88, 100);

        // Moscow
        var mskPosition = new Position.Location({:latitude => 55.7, :longitude => 37.6, :format => :degrees});
        drawTime("Moscow", mskPosition, deviceContext, 88, 120);

        // UTC
        drawUtcTime(deviceContext, 88, 140);

        // Body battery
        drawBodyBattery(deviceContext);

        // Steps
        drawStepsCount(deviceContext);

        drawTemperature(deviceContext);

        // Date
        drawDate(deviceContext);
    }

    function drawMainTime(deviceContext as Dc, x as Number, y as Number) {
        var clockTime = System.getClockTime();
        var timeString = Lang.format("$1$:$2$", [clockTime.hour, clockTime.min.format("%02d")]);
        deviceContext.drawText(x, y, Graphics.FONT_NUMBER_HOT, timeString, Graphics.TEXT_JUSTIFY_CENTER);
    }

    function drawTime(name as String, location as Toybox.Position.Location, deviceContext as Dc, x as Number, y as Number) {
        var moment = Gregorian.localMoment(location, Time.now());
        var info = Gregorian.info(moment, Time.FORMAT_SHORT);
        var timeString = Lang.format("$1$: $2$:$3$", [name, info.hour, info.min.format("%02d")]);
        deviceContext.drawText(x, y, Graphics.FONT_SMALL, timeString, Graphics.TEXT_JUSTIFY_CENTER);
    }

    function drawUtcTime(deviceContext as Dc, x as Number, y as Number) {
        var utcNumber = Time.now().value();
        var utcMoment = new Time.Moment(utcNumber);
        var utcInfo = Gregorian.utcInfo(utcMoment, Time.FORMAT_MEDIUM);
        var utcTime = Lang.format("UTC: $1$:$2$", [utcInfo.hour, utcInfo.min.format("%02d")]);
        deviceContext.drawText(88, 140, Graphics.FONT_SMALL, utcTime, Graphics.TEXT_JUSTIFY_CENTER);
    }

    function drawDate(deviceContext as Dc) {
        var today = Gregorian.info(Time.now(), Time.FORMAT_MEDIUM);
        var todayLong = Gregorian.info(Time.now(), Time.FORMAT_LONG);
        var dateString = Lang.format(
        "$1$ $2$",
        [
            today.month,
            today.day.format("%02d"),
        ]);

        deviceContext.drawText(144, 10, Graphics.FONT_TINY, dateString, Graphics.TEXT_JUSTIFY_CENTER);
        deviceContext.drawText(144, 30, Graphics.FONT_TINY, todayLong.day_of_week, Graphics.TEXT_JUSTIFY_CENTER);
    }

    function drawBodyBattery(deviceContext as Dc) {
        var text = Lang.format("Body: $1$%", [getBodyBattery()]);
        deviceContext.drawText(28, 5, Graphics.FONT_TINY, text, Graphics.TEXT_JUSTIFY_LEFT);
    }

    function getBodyBattery() {
        var bodybatt = null;
        if (
            Toybox has :SensorHistory &&
            Toybox.SensorHistory has :getBodyBatteryHistory
        ) {
            bodybatt = Toybox.SensorHistory.getBodyBatteryHistory({ :period => 1 });
        } else {
            return "N";
        }
        if (bodybatt != null) {
            bodybatt = bodybatt.next();
        }
        if (bodybatt != null) {
            bodybatt = bodybatt.data;
        }

        if (bodybatt != null && bodybatt >= 0 && bodybatt <= 100) {
            return bodybatt.format("%d");
        } else {
            return "-";
        }
    }

    function drawStepsCount(deviceContext as Dc) {
        var rawSteps = ActivityMonitor.getInfo().steps;
        var steps = rawSteps != null ? rawSteps : 0;

        var text = Lang.format("Steps: $1$", [steps]);
        deviceContext.drawText(5, 25, Graphics.FONT_TINY, text, Graphics.TEXT_JUSTIFY_LEFT);
    }

    function drawTemperature(deviceContext as Dc) {
        var currentConditions = Weather.getCurrentConditions();
        var temperature = currentConditions.temperature;
        var lowTemperature = currentConditions.lowTemperature;
        var highTemperature = currentConditions.highTemperature;

        var text = Lang.format("W: $1$°, $2$°/$3$°", [temperature.format("%2d"), lowTemperature.format("%2d"), highTemperature.format("%2d")]);
        deviceContext.drawText(2, 45, Graphics.FONT_TINY, text, Graphics.TEXT_JUSTIFY_LEFT);
    }
}
