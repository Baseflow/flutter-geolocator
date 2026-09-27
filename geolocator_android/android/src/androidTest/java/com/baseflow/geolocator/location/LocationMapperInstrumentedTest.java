package com.baseflow.geolocator.location;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;

import android.location.Location;
import android.os.Bundle;

import androidx.test.ext.junit.runners.AndroidJUnit4;

import org.junit.Test;
import org.junit.runner.RunWith;

import java.util.Map;

@RunWith(AndroidJUnit4.class)
public class LocationMapperInstrumentedTest {
  @Test
  public void mapsMeasuredVerticalSpeedFromAndroidBundle() {
    Location location = new Location("gps");
    location.setLatitude(-33.9);
    location.setLongitude(18.4);
    location.setTime(1_000L);
    Bundle extras = new Bundle();
    extras.putDouble("vertical_speed", 0.0);
    extras.putFloat("verticalSpeedAccuracy", 0.3f);
    location.setExtras(extras);

    Map<String, Object> map = LocationMapper.toHashMap(location);

    assertTrue(map.containsKey("vertical_speed"));
    assertEquals(0.0, (Double) map.get("vertical_speed"), 0.0);
    assertTrue(map.containsKey("vertical_speed_accuracy"));
    assertEquals(0.3, (Double) map.get("vertical_speed_accuracy"), 0.0001);
  }

  @Test
  public void missingExtrasDoNotClaimVerticalSpeed() {
    Location location = new Location("gps");
    location.setLatitude(-33.9);
    location.setLongitude(18.4);
    location.setTime(1_000L);

    Map<String, Object> map = LocationMapper.toHashMap(location);

    assertFalse(map.containsKey("vertical_speed"));
    assertFalse(map.containsKey("vertical_speed_accuracy"));
  }
}
