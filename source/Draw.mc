import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
using Toybox.Time;
using Toybox.Time.Gregorian;

class Draw {
    static function drawMainTime(dc as Dc, x as Number, y as Number) {
        var clockTime = System.getClockTime();
        var timeString = Lang.format("$1$:$2$", [clockTime.hour, clockTime.min.format("%02d")]);

        dc.drawText(x, y, Graphics.FONT_NUMBER_HOT, timeString, Graphics.TEXT_JUSTIFY_CENTER);
    }

    static function drawTime(name as String, location as Toybox.Position.Location, dc as Dc, x as Number, y as Number) {
        var moment = Gregorian.localMoment(location, Time.now());
        var info = Gregorian.info(moment, Time.FORMAT_SHORT);
        var timeString = Lang.format("$1$: $2$:$3$", [name, info.hour, info.min.format("%02d")]);
        dc.drawText(x, y, Graphics.FONT_SMALL, timeString, Graphics.TEXT_JUSTIFY_CENTER);
    }

    static function drawUtcTime(dc as Dc, x as Number, y as Number) {
        var utcNumber = Time.now().value();
        var utcMoment = new Time.Moment(utcNumber);
        var utcInfo = Gregorian.utcInfo(utcMoment, Time.FORMAT_MEDIUM);
        var utcTime = Lang.format("UTC: $1$:$2$", [utcInfo.hour, utcInfo.min.format("%02d")]);
        dc.drawText(x, y, Graphics.FONT_SMALL, utcTime, Graphics.TEXT_JUSTIFY_CENTER);
    }

    static function drawDate(dc as Dc) {
        var today = Gregorian.info(Time.now(), Time.FORMAT_MEDIUM);
        var todayLong = Gregorian.info(Time.now(), Time.FORMAT_LONG);
        var dateString = Lang.format(
        "$1$ $2$",
        [
            today.month,
            today.day.format("%02d"),
        ]);

        dc.drawText(144, 10, Graphics.FONT_TINY, dateString, Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(144, 30, Graphics.FONT_TINY, todayLong.day_of_week, Graphics.TEXT_JUSTIFY_CENTER);
    }

    static function drawBodyBattery(dc as Dc) {
        var text = Lang.format("Body: $1$%", [getBodyBattery()]);
        dc.drawText(28, 5, Graphics.FONT_TINY, text, Graphics.TEXT_JUSTIFY_LEFT);
    }

    static function getBodyBattery() {
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

    static function drawStepsCount(dc as Dc, steps as Number) {
        var text = Lang.format("Steps: $1$", [steps]);
        dc.drawText(5, 25, Graphics.FONT_TINY, text, Graphics.TEXT_JUSTIFY_LEFT);
    }

    static function drawTemperature(dc as Dc, temperature as Number, lowTemperature as Number, highTemperature as Number) {
        var text = Lang.format("W: $1$°, $2$°/$3$°", [temperature.format("%2d"), lowTemperature.format("%2d"), highTemperature.format("%2d")]);
        dc.drawText(2, 45, Graphics.FONT_TINY, text, Graphics.TEXT_JUSTIFY_LEFT);
    }
}