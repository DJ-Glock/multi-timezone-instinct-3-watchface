import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
using Toybox.Time;
using Toybox.Time.Gregorian;

class Draw {
    static function drawMainTime(label as Toybox.WatchUi.Text) {
        var clockTime = System.getClockTime();
        var timeString = Lang.format("$1$:$2$", [clockTime.hour, clockTime.min.format("%02d")]);
        label.setText(timeString);
    }

    static function drawTime(name as String, location as Toybox.Position.Location, label as Toybox.WatchUi.Text) {
        var moment = Gregorian.localMoment(location, Time.now());
        var info = Gregorian.info(moment, Time.FORMAT_SHORT);
        var timeString = Lang.format("$1$: $2$:$3$", [name, info.hour, info.min.format("%02d")]);
        label.setText(timeString);
    }

    static function drawUtcTime(label as Toybox.WatchUi.Text) {
        var utcNumber = Time.now().value();
        var utcMoment = new Time.Moment(utcNumber);
        var utcInfo = Gregorian.utcInfo(utcMoment, Time.FORMAT_MEDIUM);
        var utcTime = Lang.format("UTC: $1$:$2$", [utcInfo.hour, utcInfo.min.format("%02d")]);
        label.setText(utcTime);
    }

    static function drawDate(dateLabel as Toybox.WatchUi.Text, dayLabel as Toybox.WatchUi.Text) {
        var today = Gregorian.info(Time.now(), Time.FORMAT_MEDIUM);
        var todayLong = Gregorian.info(Time.now(), Time.FORMAT_LONG);
        var dateString = Lang.format(
        "$1$ $2$",
        [
            today.month,
            today.day.format("%02d"),
        ]);

        dateLabel.setText(dateString);
        dayLabel.setText(todayLong.day_of_week);
    }

    static function drawBodyBattery(label as Toybox.WatchUi.Text) {
        var text = Lang.format("Body: $1$%", [getBodyBattery()]);
        label.setText(text);
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

    static function drawStepsCount(label as Toybox.WatchUi.Text, steps as Number) {
        var text = Lang.format("Steps: $1$", [steps]);
        label.setText(text);
    }

    static function drawTemperature(label as Toybox.WatchUi.Text, temperature as Number, lowTemperature as Number, highTemperature as Number) {
        var text = Lang.format("W: $1$°, $2$°/$3$°", [temperature.format("%2d"), lowTemperature.format("%2d"), highTemperature.format("%2d")]);
        label.setText(text);
    }
}