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
        var clockTime = System.getClockTime();
        var timeString = Lang.format("$1$:$2$", [clockTime.hour, clockTime.min.format("%02d")]);
        deviceContext.drawText(88, 60, Graphics.FONT_NUMBER_HOT, timeString, Graphics.TEXT_JUSTIFY_CENTER);

        // New York
        var nyPosition = new Position.Location({:latitude => 40.7, :longitude => -74.0, :format => :degrees});
        var nyTime = getTime("New York", nyPosition);
        deviceContext.drawText(88, 100, Graphics.FONT_SMALL, nyTime, Graphics.TEXT_JUSTIFY_CENTER);

        // Moscow
        var mskPosition = new Position.Location({:latitude => 55.7, :longitude => 37.6, :format => :degrees});
        var mskTime = getTime("Moscow", mskPosition);
        deviceContext.drawText(88, 120, Graphics.FONT_SMALL, mskTime, Graphics.TEXT_JUSTIFY_CENTER);

        // UTC
        deviceContext.drawText(88, 140, Graphics.FONT_SMALL, getUtcTime(), Graphics.TEXT_JUSTIFY_CENTER);

        // Date
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

    function getTime(name as String, location as Toybox.Position.Location) as String {
        var moment = Gregorian.localMoment(location, Time.now());
        var info = Gregorian.info(moment, Time.FORMAT_SHORT);
        var timeString = Lang.format("$1$: $2$:$3$", [name, info.hour, info.min.format("%02d")]);
        return timeString;
    }

    function getUtcTime() as String {
        var utcNumber = Time.now().value();
        var utcMoment = new Time.Moment(utcNumber);
        var utcInfo = Gregorian.utcInfo(utcMoment, Time.FORMAT_MEDIUM);
        var utcTime = Lang.format("UTC: $1$:$2$", [utcInfo.hour, utcInfo.min.format("%02d")]);
        return utcTime;
    }
}
