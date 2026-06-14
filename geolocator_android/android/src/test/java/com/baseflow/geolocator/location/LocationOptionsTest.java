package com.baseflow.geolocator.location;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNull;

import org.junit.Test;

import java.util.HashMap;
import java.util.Map;

public class LocationOptionsTest {
  @Test
  public void parseArguments_setsMaxUpdateAgeMillis() {
    // Arrange
    Map<String, Object> arguments = new HashMap<>();
    arguments.put("maxUpdateAge", 30000);

    // Act
    LocationOptions options = LocationOptions.parseArguments(arguments);

    // Assert
    assertEquals(Long.valueOf(30000), options.getMaxUpdateAgeMillis());
  }

  @Test
  public void parseArguments_defaultsMaxUpdateAgeMillisToNull() {
    // Act
    LocationOptions options = LocationOptions.parseArguments(new HashMap<>());

    // Assert
    assertNull(options.getMaxUpdateAgeMillis());
  }
}
