package com.baseflow.geolocator.location;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;

import android.location.Location;
import android.os.Bundle;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.robolectric.RobolectricTestRunner;
import org.robolectric.annotation.Config;

import java.util.Map;

@RunWith(RobolectricTestRunner.class)
@Config(sdk = {28, 33, 34})
public class LocationMapperBundleTest {
  @Test
  public void mapsMixedNumericProviderExtras() {
    Location location = new Location("gps");
    Bundle extras = new Bundle();
    extras.putInt("vertical_speed", -2);
    extras.putFloat("verticalSpeedAccuracy", 0.25f);
    location.setExtras(extras);

    Map<String, Object> map = LocationMapper.toHashMap(location);

    assertEquals(-2.0, (Double) map.get("vertical_speed"), 0.0);
    assertEquals(0.25, (Double) map.get("vertical_speed_accuracy"), 0.0);
  }

  @Test
  public void skipsNonNumericExtrasAndUsesNextProviderKey() {
    Location location = new Location("gps");
    Bundle extras = new Bundle();
    extras.putString(NmeaClient.VERTICAL_SPEED_EXTRA, "not a measurement");
    extras.putLong("vertical_speed", 3L);
    extras.putParcelable(NmeaClient.VERTICAL_SPEED_ACCURACY_EXTRA, new Bundle());
    location.setExtras(extras);

    Map<String, Object> map = LocationMapper.toHashMap(location);

    assertEquals(3.0, (Double) map.get("vertical_speed"), 0.0);
    assertFalse(map.containsKey("vertical_speed_accuracy"));
  }
}
