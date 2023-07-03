package com.baseflow.geolocator;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertTrue;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyBoolean;
import static org.mockito.Mockito.doAnswer;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import android.location.Location;

import com.baseflow.geolocator.errors.PermissionUndefinedException;
import com.baseflow.geolocator.location.GeolocationManager;
import com.baseflow.geolocator.location.LocationAccuracyManager;
import com.baseflow.geolocator.location.LocationClient;
import com.baseflow.geolocator.location.LocationMapper;
import com.baseflow.geolocator.location.PositionChangedCallback;
import com.baseflow.geolocator.permission.PermissionManager;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import org.mockito.ArgumentCaptor;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import org.mockito.stubbing.Answer;

import java.util.HashMap;
import java.util.Map;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class MethodCallHandlerImplTest {
  @Mock PermissionManager mockPermissionManager;
  @Mock GeolocationManager mockGeolocationManager;
  @Mock LocationAccuracyManager mockLocationAccuracyManager;
  @Mock Location mockLocation;
  @Mock LocationClient mockLocationClient;
  @Mock AutoCloseable mockCloseable;

  @Before
  public void setUp() throws PermissionUndefinedException {
    mockCloseable = MockitoAnnotations.openMocks(this);

    when(mockLocation.getLatitude()).thenReturn(10.0);
    when(mockLocation.getLongitude()).thenReturn(20.0);
    when(mockLocation.getTime()).thenReturn(30L);
    when(mockLocation.isMock()).thenReturn(false);
    when(mockPermissionManager.hasPermission(any())).thenReturn(true);
    when(mockGeolocationManager.createLocationClient(any(), anyBoolean(), any()))
        .thenReturn(mockLocationClient);
  }

  @After
  public void tearDown() throws Exception {
    mockCloseable.close();
  }

  @Test
  public void onGetCurrentPosition_getsPosition() {
    // Arrange
    MethodCallHandlerImpl methodCallHandler = createMethodCallHandler();
    MethodChannel.Result mockResult = mock(MethodChannel.Result.class);

    final ArgumentCaptor<PositionChangedCallback> callbackCaptor =
        ArgumentCaptor.forClass(PositionChangedCallback.class);
    Answer<Void> answer = invocation -> {
      callbackCaptor.getValue().onPositionChanged(mockLocation);
      return null;
    };
    doAnswer(answer)
        .when(mockGeolocationManager)
        .startPositionUpdates(any(), any(), callbackCaptor.capture(), any());

    Map<String, Object> arguments = new HashMap<>();
    ArgumentCaptor<Object> resultCaptor = ArgumentCaptor.forClass(Object.class);
    Map<String, Object> expectedJson = LocationMapper.toHashMap(mockLocation);

    // Act
    methodCallHandler.onMethodCall(new MethodCall("getCurrentPosition", arguments), mockResult);

    // Assert
    verify(mockResult).success(resultCaptor.capture());
    assertEquals(expectedJson, resultCaptor.getValue());
  }

  @Test
  public void onGetCurrentPosition_setsPendingLocationClient() {
    // Arrange
    MethodCallHandlerImpl methodCallHandler = createMethodCallHandler();
    MethodChannel.Result mockResult = mock(MethodChannel.Result.class);

    String requestId = "example_request_id";
    Map<String, Object> arguments = new HashMap<>();
    arguments.put("requestId", requestId);

    // Act
    methodCallHandler.onMethodCall(new MethodCall("getCurrentPosition", arguments), mockResult);

    // Assert
    assertTrue(methodCallHandler.pendingCurrentPositionLocationClients.containsKey(requestId));
  }

  @Test
  public void onCancelGetCurrentPosition_clearsPendingLocationClient() {
    // Arrange
    MethodCallHandlerImpl methodCallHandler = createMethodCallHandler();
    MethodChannel.Result mockResult = mock(MethodChannel.Result.class);

    String requestId = "example_request_id";
    methodCallHandler.pendingCurrentPositionLocationClients.put(requestId, null);
    Map<String, Object> arguments = new HashMap<>();
    arguments.put("requestId", requestId);

    // Act
    methodCallHandler.onMethodCall(new MethodCall("cancelGetCurrentPosition", arguments), mockResult);

    // Assert
    assertTrue(methodCallHandler.pendingCurrentPositionLocationClients.isEmpty());
  }

  private MethodCallHandlerImpl createMethodCallHandler() {
    return new MethodCallHandlerImpl(
        mockPermissionManager,
        mockGeolocationManager,
        mockLocationAccuracyManager
    );
  }
}
