package com.baseflow.geolocator;

import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;
import static org.mockito.Mockito.when;

import android.location.Location;

import com.baseflow.geolocator.location.LocationAccuracyFilter;

import org.junit.Before;
import org.junit.Test;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;

public class LocationAccuracyFilterTest {
    @Mock private Location mockLocation1;
    @Mock private Location mockLocation2;

    @Before
    public void setUp() {
        MockitoAnnotations.openMocks(this);
        // Reset the filter state before each test
        LocationAccuracyFilter.reset();
        // Enable filtering by default for tests
        LocationAccuracyFilter.setFilterEnabled(true);
    }

    @Test
    public void shouldAcceptLocation_withFirstLocation_returnsTrue() {
        // Arrange
        when(mockLocation1.getTime()).thenReturn(1000L);
        when(mockLocation1.hasAccuracy()).thenReturn(true);
        when(mockLocation1.getAccuracy()).thenReturn(10.0f);

        // Act & Assert
        assertTrue(LocationAccuracyFilter.shouldAcceptLocation(mockLocation1));
    }

    @Test
    public void shouldAcceptLocation_withPoorAccuracy_returnsFalse() {
        // Arrange - First accepted location
        when(mockLocation1.getTime()).thenReturn(1000L);
        when(mockLocation1.hasAccuracy()).thenReturn(true);
        when(mockLocation1.getAccuracy()).thenReturn(10.0f);
        LocationAccuracyFilter.shouldAcceptLocation(mockLocation1);

        // Arrange - Second location with poor accuracy
        when(mockLocation2.getTime()).thenReturn(2000L);
        when(mockLocation2.hasAccuracy()).thenReturn(true);
        when(mockLocation2.getAccuracy()).thenReturn(350.0f); // Above threshold
        when(mockLocation2.distanceTo(mockLocation1)).thenReturn(50.0f);

        // Act & Assert
        assertFalse(LocationAccuracyFilter.shouldAcceptLocation(mockLocation2));
    }

    @Test
    public void shouldAcceptLocation_withUnrealisticSpeed_returnsFalse() {
        // Arrange - First accepted location
        when(mockLocation1.getTime()).thenReturn(1000L);
        when(mockLocation1.hasAccuracy()).thenReturn(true);
        when(mockLocation1.getAccuracy()).thenReturn(10.0f);
        LocationAccuracyFilter.shouldAcceptLocation(mockLocation1);

        // Arrange - Second location with unrealistic speed (5000m in 1 second = 5000 m/s)
        when(mockLocation2.getTime()).thenReturn(2000L);
        when(mockLocation2.hasAccuracy()).thenReturn(true);
        when(mockLocation2.getAccuracy()).thenReturn(10.0f);
        when(mockLocation2.distanceTo(mockLocation1)).thenReturn(5000.0f);

        // Act & Assert
        assertFalse(LocationAccuracyFilter.shouldAcceptLocation(mockLocation2));
    }

    @Test
    public void shouldAcceptLocation_withLargeJumpAndModerateAccuracy_returnsFalse() {
        // Arrange - First accepted location
        when(mockLocation1.getTime()).thenReturn(1000L);
        when(mockLocation1.hasAccuracy()).thenReturn(true);
        when(mockLocation1.getAccuracy()).thenReturn(10.0f);
        LocationAccuracyFilter.shouldAcceptLocation(mockLocation1);

        // Arrange - Second location with large jump and moderate accuracy
        when(mockLocation2.getTime()).thenReturn(2000L);
        when(mockLocation2.hasAccuracy()).thenReturn(true);
        when(mockLocation2.getAccuracy()).thenReturn(80.0f); // Moderate accuracy
        when(mockLocation2.distanceTo(mockLocation1)).thenReturn(2000.0f); // Large jump

        // Act & Assert
        assertFalse(LocationAccuracyFilter.shouldAcceptLocation(mockLocation2));
    }

    @Test
    public void shouldAcceptLocation_withNormalMovement_returnsTrue() {
        // Arrange - First accepted location
        when(mockLocation1.getTime()).thenReturn(1000L);
        when(mockLocation1.hasAccuracy()).thenReturn(true);
        when(mockLocation1.getAccuracy()).thenReturn(10.0f);
        LocationAccuracyFilter.shouldAcceptLocation(mockLocation1);

        // Arrange - Second location with normal movement (50m in 10 seconds = 5 m/s)
        when(mockLocation2.getTime()).thenReturn(11000L);
        when(mockLocation2.hasAccuracy()).thenReturn(true);
        when(mockLocation2.getAccuracy()).thenReturn(10.0f);
        when(mockLocation2.distanceTo(mockLocation1)).thenReturn(50.0f);

        // Act & Assert
        assertTrue(LocationAccuracyFilter.shouldAcceptLocation(mockLocation2));
    }

    @Test
    public void shouldAcceptLocation_withResetBetweenLocations_returnsTrue() {
        // Arrange - First accepted location
        when(mockLocation1.getTime()).thenReturn(1000L);
        when(mockLocation1.hasAccuracy()).thenReturn(true);
        when(mockLocation1.getAccuracy()).thenReturn(10.0f);
        LocationAccuracyFilter.shouldAcceptLocation(mockLocation1);

        // Reset the filter
        LocationAccuracyFilter.reset();

        // Arrange - Second location that would normally be rejected (5000m in 1 second = 5000 m/s)
        when(mockLocation2.getTime()).thenReturn(2000L);
        when(mockLocation2.hasAccuracy()).thenReturn(true);
        when(mockLocation2.getAccuracy()).thenReturn(10.0f);
        when(mockLocation2.distanceTo(mockLocation1)).thenReturn(5000.0f);

        // Act & Assert - Should be accepted because filter was reset
        assertTrue(LocationAccuracyFilter.shouldAcceptLocation(mockLocation2));
    }
    
    @Test
    public void shouldAcceptLocation_withRealisticTransportationSpeeds() {
        // Arrange - First accepted location
        when(mockLocation1.getTime()).thenReturn(1000L);
        when(mockLocation1.hasAccuracy()).thenReturn(true);
        when(mockLocation1.getAccuracy()).thenReturn(10.0f);
        LocationAccuracyFilter.shouldAcceptLocation(mockLocation1);

        // Test case 1: Airplane speed (900 km/h = 250 m/s)
        // 1000 meters in 4 seconds = 250 m/s
        when(mockLocation2.getTime()).thenReturn(5000L); // 4 seconds later
        when(mockLocation2.hasAccuracy()).thenReturn(true);
        when(mockLocation2.getAccuracy()).thenReturn(15.0f); // Good accuracy
        when(mockLocation2.distanceTo(mockLocation1)).thenReturn(1000.0f);
        
        // Should NOT accept airplane-like movement (exceeds threshold of 120 m/s)
        assertFalse(LocationAccuracyFilter.shouldAcceptLocation(mockLocation2));
        
        // Reset for next test
        LocationAccuracyFilter.reset();
        LocationAccuracyFilter.shouldAcceptLocation(mockLocation1);
        
        // Test case 2: High-speed train (300 km/h = 83.3 m/s)
        // 833 meters in 10 seconds = 83.3 m/s
        when(mockLocation2.getTime()).thenReturn(11000L); // 10 seconds later
        when(mockLocation2.hasAccuracy()).thenReturn(true);
        when(mockLocation2.getAccuracy()).thenReturn(15.0f); // Good accuracy
        when(mockLocation2.distanceTo(mockLocation1)).thenReturn(833.0f);
        
        // Should accept high-speed train movement
        assertTrue(LocationAccuracyFilter.shouldAcceptLocation(mockLocation2));
        
        // Reset for next test
        LocationAccuracyFilter.reset();
        LocationAccuracyFilter.shouldAcceptLocation(mockLocation1);
        
        // Test case 3: Fast car on highway (120 km/h = 33.3 m/s)
        // 333 meters in 10 seconds = 33.3 m/s
        when(mockLocation2.getTime()).thenReturn(11000L); // 10 seconds later
        when(mockLocation2.hasAccuracy()).thenReturn(true);
        when(mockLocation2.getAccuracy()).thenReturn(15.0f); // Good accuracy
        when(mockLocation2.distanceTo(mockLocation1)).thenReturn(333.0f);
        
        // Should accept fast car movement
        assertTrue(LocationAccuracyFilter.shouldAcceptLocation(mockLocation2));
    }

    @Test
    public void shouldAcceptLocation_whenFilterDisabled_alwaysReturnsTrue() {
        // Arrange
        // Disable filtering
        LocationAccuracyFilter.setFilterEnabled(false);
        
        // Set up first location
        when(mockLocation1.getTime()).thenReturn(1000L);
        when(mockLocation1.hasAccuracy()).thenReturn(true);
        when(mockLocation1.getAccuracy()).thenReturn(10.0f);
        LocationAccuracyFilter.shouldAcceptLocation(mockLocation1);
        
        // Set up second location that would normally be filtered (unrealistic speed)
        when(mockLocation2.getTime()).thenReturn(2000L);
        when(mockLocation2.hasAccuracy()).thenReturn(true);
        when(mockLocation2.getAccuracy()).thenReturn(10.0f);
        when(mockLocation2.distanceTo(mockLocation1)).thenReturn(5000.0f); // 5000m in 1s = 5000 m/s

        // Act & Assert - Should be accepted because filtering is disabled
        assertTrue(LocationAccuracyFilter.shouldAcceptLocation(mockLocation2));
        
        // Make sure to enable filtering again for other tests
        LocationAccuracyFilter.setFilterEnabled(true);
    }
} 