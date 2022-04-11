package com.baseflow.geolocator.location;

import java.util.HashMap;
import java.util.Locale;
import java.util.Map;

public class NmeaMapper {

    public static Map<String, Object> toHashMap(String message) {
        if (message == null) {
            return null;
        }

        Map<String, Object> nmeaMessage = new HashMap<>();

        if (message.startsWith("$")) {

            nmeaMessage.put("nmeaMessage", message);
            nmeaMessage.putAll(tryParseGPGAAMessage(message));
        }


        return nmeaMessage;
    }

    private static Map<String, Object> tryParseGPGAAMessage(String message) {

        Map<String, Object> parsedMessage = new HashMap<>();

        String[] tokens = message.split(",");
        String type = tokens[0];
        // Parse altitude above sea level, Detailed description of NMEA string here
        // http://aprs.gids.nl/nmea/#gga
        if (type.startsWith("$GPGGA") && tokens.length > 9) {

            parsedMessage.put("time", tokens[1]);
            parsedMessage.put("latitude", tokens[2] + ',' + tokens[3]);
            parsedMessage.put("longitude", tokens[4] + ',' + tokens[5]);
            parsedMessage.put("quality", Integer.parseInt(tokens[6]));
            parsedMessage.put("numberOfSatellites", Integer.parseInt(tokens[7]));
            parsedMessage.put("horizontalDilutionOfPrecision", Double.parseDouble(tokens[8]));
            parsedMessage.put("altitude", Double.parseDouble(tokens[9]));
            parsedMessage.put("heightAboveEllipsoid", Double.parseDouble(tokens[11]));
        }

        return parsedMessage;
    }
}
