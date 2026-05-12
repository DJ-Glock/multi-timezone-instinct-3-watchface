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
        if (
            Toybox has :SensorHistory &&
            Toybox.SensorHistory has :getBodyBatteryHistory
        ) {
            var batteryHistory = Toybox.SensorHistory.getBodyBatteryHistory({
                :period => 1,
            });
            
            var bodybatt = batteryHistory.next().data;
            if (bodybatt != null && bodybatt >= 0 && bodybatt <= 100) {
                return bodybatt.format("%d");
            } else {
                return "-";
            }
        } else {
            return "N";
        }
    }
}
