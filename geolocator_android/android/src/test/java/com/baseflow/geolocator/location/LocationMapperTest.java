package com.baseflow.geolocator.location;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertNull;
import static org.junit.Assert.assertTrue;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;

import android.location.Location;
import android.os.Bundle;

import org.junit.Test;

import java.util.Map;

public class LocationMapperTest {

  @Test
  public void toHashMap_returnsNullWhenLocationIsNull() {
    assertNull(LocationMapper.toHashMap(null));
  }

  @Test
  public void toHashMap_omitsVerticalSpeedWhenNotProvided() {
    Location location = mock(Location.class);
    when(location.getLatitude()).thenReturn(52.0);
    when(location.getLongitude()).thenReturn(5.0);
    when(location.getTime()).thenReturn(1000L);
    when(location.getExtras()).thenReturn(null);

    Map<String, Object> map = LocationMapper.toHashMap(location);

    assertFalse(map.containsKey("vertical_speed"));
    assertFalse(map.containsKey("vertical_speed_accuracy"));
  }

  @Test
  public void toHashMap_mapsVerticalSpeedAndAccuracyFromExtras() {
    Location location = mock(Location.class);
    when(location.getLatitude()).thenReturn(52.0);
    when(location.getLongitude()).thenReturn(5.0);
    when(location.getTime()).thenReturn(1000L);

    Bundle extras = mock(Bundle.class);
    when(extras.containsKey(NmeaClient.VERTICAL_SPEED_EXTRA)).thenReturn(true);
    when(extras.get(NmeaClient.VERTICAL_SPEED_EXTRA)).thenReturn(2.5);
    when(extras.containsKey(NmeaClient.VERTICAL_SPEED_ACCURACY_EXTRA)).thenReturn(true);
    when(extras.get(NmeaClient.VERTICAL_SPEED_ACCURACY_EXTRA)).thenReturn(0.3);
    when(location.getExtras()).thenReturn(extras);

    Map<String, Object> map = LocationMapper.toHashMap(location);

    assertTrue(map.containsKey("vertical_speed"));
    assertEquals(2.5, (Double) map.get("vertical_speed"), 0.0001);
    assertTrue(map.containsKey("vertical_speed_accuracy"));
    assertEquals(0.3, (Double) map.get("vertical_speed_accuracy"), 0.0001);
  }

  @Test
  public void toHashMap_mapsVerticalSpeedFallbackKey() {
    Location location = mock(Location.class);
    when(location.getLatitude()).thenReturn(52.0);
    when(location.getLongitude()).thenReturn(5.0);
    when(location.getTime()).thenReturn(1000L);

    Bundle extras = mock(Bundle.class);
    when(extras.containsKey("vertical_speed")).thenReturn(true);
    when(extras.get("vertical_speed")).thenReturn(-1.8);
    when(extras.containsKey("vertical_speed_accuracy")).thenReturn(true);
    when(extras.get("vertical_speed_accuracy")).thenReturn(0.5);
    when(location.getExtras()).thenReturn(extras);

    Map<String, Object> map = LocationMapper.toHashMap(location);

    assertTrue(map.containsKey("vertical_speed"));
    assertEquals(-1.8, (Double) map.get("vertical_speed"), 0.0001);
    assertTrue(map.containsKey("vertical_speed_accuracy"));
    assertEquals(0.5, (Double) map.get("vertical_speed_accuracy"), 0.0001);
  }

  @Test
  public void toHashMap_mapsFloatExtrasCorrectlyWithoutClassCastException() {
    Location location = mock(Location.class);
    when(location.getLatitude()).thenReturn(52.0);
    when(location.getLongitude()).thenReturn(5.0);
    when(location.getTime()).thenReturn(1000L);

    Bundle extras = mock(Bundle.class);
    when(extras.containsKey(NmeaClient.VERTICAL_SPEED_EXTRA)).thenReturn(true);
    when(extras.get(NmeaClient.VERTICAL_SPEED_EXTRA)).thenReturn(3.75f);
    when(extras.containsKey(NmeaClient.VERTICAL_SPEED_ACCURACY_EXTRA)).thenReturn(true);
    when(extras.get(NmeaClient.VERTICAL_SPEED_ACCURACY_EXTRA)).thenReturn(0.25f);
    when(location.getExtras()).thenReturn(extras);

    Map<String, Object> map = LocationMapper.toHashMap(location);

    assertTrue(map.containsKey("vertical_speed"));
    assertEquals(3.75, (Double) map.get("vertical_speed"), 0.0001);
    assertTrue(map.containsKey("vertical_speed_accuracy"));
    assertEquals(0.25, (Double) map.get("vertical_speed_accuracy"), 0.0001);
  }

  @Test
  public void toHashMap_omitsNaNAndInfiniteValues() {
    Location location = mock(Location.class);
    when(location.getLatitude()).thenReturn(52.0);
    when(location.getLongitude()).thenReturn(5.0);
    when(location.getTime()).thenReturn(1000L);

    Bundle extras = mock(Bundle.class);
    when(extras.containsKey(NmeaClient.VERTICAL_SPEED_EXTRA)).thenReturn(true);
    when(extras.get(NmeaClient.VERTICAL_SPEED_EXTRA)).thenReturn(Double.NaN);
    when(extras.containsKey(NmeaClient.VERTICAL_SPEED_ACCURACY_EXTRA)).thenReturn(true);
    when(extras.get(NmeaClient.VERTICAL_SPEED_ACCURACY_EXTRA)).thenReturn(Double.POSITIVE_INFINITY);
    when(location.getExtras()).thenReturn(extras);

    Map<String, Object> map = LocationMapper.toHashMap(location);

    assertFalse(map.containsKey("vertical_speed"));
    assertFalse(map.containsKey("vertical_speed_accuracy"));
  }

  @Test
  public void toHashMap_omitsNegativeAccuracy() {
    Location location = mock(Location.class);
    when(location.getLatitude()).thenReturn(52.0);
    when(location.getLongitude()).thenReturn(5.0);
    when(location.getTime()).thenReturn(1000L);

    Bundle extras = mock(Bundle.class);
    when(extras.containsKey(NmeaClient.VERTICAL_SPEED_EXTRA)).thenReturn(true);
    when(extras.get(NmeaClient.VERTICAL_SPEED_EXTRA)).thenReturn(1.5);
    when(extras.containsKey(NmeaClient.VERTICAL_SPEED_ACCURACY_EXTRA)).thenReturn(true);
    when(extras.get(NmeaClient.VERTICAL_SPEED_ACCURACY_EXTRA)).thenReturn(-1.0);
    when(location.getExtras()).thenReturn(extras);

    Map<String, Object> map = LocationMapper.toHashMap(location);

    assertTrue(map.containsKey("vertical_speed"));
    assertEquals(1.5, (Double) map.get("vertical_speed"), 0.0001);
    assertFalse(map.containsKey("vertical_speed_accuracy"));
  }

  @Test
  public void toHashMap_prefersStandardKeyOverFallback() {
    Location location = mock(Location.class);
    when(location.getLatitude()).thenReturn(52.0);
    when(location.getLongitude()).thenReturn(5.0);
    when(location.getTime()).thenReturn(1000L);

    Bundle extras = mock(Bundle.class);
    when(extras.containsKey(NmeaClient.VERTICAL_SPEED_EXTRA)).thenReturn(true);
    when(extras.get(NmeaClient.VERTICAL_SPEED_EXTRA)).thenReturn(4.2);
    when(extras.containsKey("vertical_speed")).thenReturn(true);
    when(extras.get("vertical_speed")).thenReturn(1.1);
    when(location.getExtras()).thenReturn(extras);

    Map<String, Object> map = LocationMapper.toHashMap(location);

    assertTrue(map.containsKey("vertical_speed"));
    assertEquals(4.2, (Double) map.get("vertical_speed"), 0.0001);
  }
}
