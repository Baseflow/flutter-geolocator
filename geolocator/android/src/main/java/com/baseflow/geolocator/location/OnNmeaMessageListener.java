package android.location;

/**
 * Used for receiving NMEA sentences from the GNSS.
 * NMEA 0183 is a standard for communicating with marine electronic devices
 * and is a common method for receiving data from a GNSS, typically over a serial port.
 * See <a href="http://en.wikipedia.org/wiki/NMEA_0183">NMEA 0183</a> for more details.
 * You can implement this interface and call {@link LocationManager#addNmeaListener}
 * to receive NMEA data from the GNSS engine.
 */
public interface OnNmeaMessageListener {
  /**
   * Called when an NMEA message is received.
   * @param message NMEA message
   * @param timestamp milliseconds since January 1, 1970.
   */
  void onNmeaMessage(String message, long timestamp);
}