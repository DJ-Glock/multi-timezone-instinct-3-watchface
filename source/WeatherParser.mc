import Toybox.Lang;
import Toybox.Weather;

class WeatherParser {
    static function parseWeatherCondition(condition as Number) as String {
        switch (condition) {
            case Weather.CONDITION_CLEAR: return "Clear";
            case Weather.CONDITION_PARTLY_CLOUDY: return "Partly cloudy";
            case Weather.CONDITION_MOSTLY_CLOUDY: return "Mostly cloudy";
            case Weather.CONDITION_RAIN: return "Rain";
            case Weather.CONDITION_SNOW: return "Snow";
            case Weather.CONDITION_WINDY: return "Windy";
            case Weather.CONDITION_THUNDERSTORMS: return "Thunderstorms";
            case Weather.CONDITION_WINTRY_MIX: return "Wintry mix";
            case Weather.CONDITION_FOG: return "Fog";
            case Weather.CONDITION_HAZY: return "Hazy";
            case Weather.CONDITION_HAIL: return "Hail";
            case Weather.CONDITION_SCATTERED_SHOWERS: return "Showers";
            case Weather.CONDITION_SCATTERED_THUNDERSTORMS: return "Thunderstorms";
            case Weather.CONDITION_UNKNOWN_PRECIPITATION: return "Freezing rain!";
            case Weather.CONDITION_LIGHT_RAIN: return "Light rain";
            case Weather.CONDITION_HEAVY_RAIN: return "Heavy rain";
            case Weather.CONDITION_LIGHT_SNOW: return "Light snow";
            case Weather.CONDITION_HEAVY_SNOW: return "Heavy snow";
            case Weather.CONDITION_LIGHT_RAIN_SNOW: return "Rain snow";
            case Weather.CONDITION_HEAVY_RAIN_SNOW: return "Rain snow";
            case Weather.CONDITION_CLOUDY: return "Cloudy";
            case Weather.CONDITION_RAIN_SNOW: return "Rain snow";
            case Weather.CONDITION_PARTLY_CLEAR: return "Partly clear";
            case Weather.CONDITION_MOSTLY_CLEAR: return "Mostly clear";
            case Weather.CONDITION_LIGHT_SHOWERS: return "Light showers";
            case Weather.CONDITION_SHOWERS: return "Showers";
            case Weather.CONDITION_HEAVY_SHOWERS: return "Heavy showers";
            case Weather.CONDITION_CHANCE_OF_SHOWERS: return "Showers";
            case Weather.CONDITION_CHANCE_OF_THUNDERSTORMS: return "Thunderstorms";
            case Weather.CONDITION_MIST: return "Mist";
            case Weather.CONDITION_DUST: return "Dust";
            case Weather.CONDITION_DRIZZLE: return "Drizzle";
            case Weather.CONDITION_TORNADO: return "Tornado!";
            case Weather.CONDITION_SMOKE: return "Smoke";
            case Weather.CONDITION_ICE: return "Ice";
            case Weather.CONDITION_SAND: return "Sand";
            case Weather.CONDITION_SQUALL: return "Squall";
            case Weather.CONDITION_SANDSTORM: return "Sandstorm!";
            case Weather.CONDITION_VOLCANIC_ASH: return "Volcanic ash!";
            case Weather.CONDITION_HAZE: return "Haze";
            case Weather.CONDITION_FAIR: return "Fair";
            case Weather.CONDITION_HURRICANE: return "Hurricane!";
            case Weather.CONDITION_TROPICAL_STORM: return "Tropical storm!";
            case Weather.CONDITION_CHANCE_OF_SNOW: return "Snow";
            case Weather.CONDITION_CHANCE_OF_RAIN_SNOW: return "Rain snow";
            case Weather.CONDITION_CLOUDY_CHANCE_OF_RAIN: return "Rain";
            case Weather.CONDITION_CLOUDY_CHANCE_OF_SNOW: return "Snow";
            case Weather.CONDITION_CLOUDY_CHANCE_OF_RAIN_SNOW: return "Rain snow";
            case Weather.CONDITION_FLURRIES: return "Snow";
            case Weather.CONDITION_FREEZING_RAIN: return "Freezing rain!";
            case Weather.CONDITION_SLEET: return "Sleet";
            case Weather.CONDITION_ICE_SNOW: return "Ice snow";
            case Weather.CONDITION_THIN_CLOUDS: return "Thin clouds";
            case Weather.CONDITION_UNKNOWN: return "Unknown";
            default: return "-";
        }
    }
}