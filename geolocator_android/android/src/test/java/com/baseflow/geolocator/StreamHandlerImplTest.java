package com.baseflow.geolocator;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyBoolean;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.ArgumentMatchers.isNull;
import static org.mockito.ArgumentMatchers.notNull;
import static org.mockito.Mockito.mockStatic;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import android.app.Activity;
import android.content.Context;
import android.util.Log;

import com.baseflow.geolocator.errors.PermissionUndefinedException;
import com.baseflow.geolocator.location.GeolocationManager;
import com.baseflow.geolocator.location.LocationClient;
import com.baseflow.geolocator.permission.PermissionManager;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import org.mockito.Mock;
import org.mockito.MockedStatic;
import org.mockito.MockitoAnnotations;

import java.util.HashMap;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.EventChannel;

public class StreamHandlerImplTest {
  private static final String CHANNEL_NAME = "flutter.baseflow.com/geolocator_updates_android";

  @Mock PermissionManager mockPermissionManager;
  @Mock GeolocationManager mockGeolocationManager;
  @Mock GeolocatorLocationService mockForegroundLocationService;
  @Mock LocationClient mockLocationClient;
  @Mock BinaryMessenger mockMessenger;
  @Mock Context mockContext;
  @Mock Activity mockActivity;
  @Mock EventChannel.EventSink mockEventSink;
  AutoCloseable mockCloseable;
  // android.util.Log is a stub in local unit tests and throws unless it is mocked.
  MockedStatic<Log> mockLog;

  @Before
  public void setUp() throws PermissionUndefinedException {
    mockCloseable = MockitoAnnotations.openMocks(this);
    mockLog = mockStatic(Log.class);

    when(mockPermissionManager.hasPermission(any())).thenReturn(true);
    when(mockGeolocationManager.createLocationClient(any(), anyBoolean(), any()))
        .thenReturn(mockLocationClient);
  }

  @After
  public void tearDown() throws Exception {
    mockLog.close();
    mockCloseable.close();
  }

  @Test
  public void setActivity_whenDetachedDuringPositionStream_keepsEventChannelRegistered() {
    // Arrange
    StreamHandlerImpl streamHandler = createListeningStreamHandler();

    // Act
    streamHandler.setActivity(null);

    // Assert
    verify(mockMessenger, never()).setMessageHandler(eq(CHANNEL_NAME), isNull());
  }

  @Test
  public void setActivity_whenDetachedDuringPositionStream_stopsPositionUpdates() {
    // Arrange
    StreamHandlerImpl streamHandler = createListeningStreamHandler();

    // Act
    streamHandler.setActivity(null);

    // Assert
    verify(mockGeolocationManager).stopPositionUpdates(mockLocationClient);
  }

  @Test
  public void stopListening_unregistersEventChannel() {
    // Arrange
    StreamHandlerImpl streamHandler = createListeningStreamHandler();

    // Act
    streamHandler.stopListening();

    // Assert
    verify(mockMessenger).setMessageHandler(eq(CHANNEL_NAME), isNull());
    verify(mockGeolocationManager).stopPositionUpdates(mockLocationClient);
  }

  private StreamHandlerImpl createListeningStreamHandler() {
    StreamHandlerImpl streamHandler =
        new StreamHandlerImpl(mockPermissionManager, mockGeolocationManager);
    streamHandler.startListening(mockContext, mockMessenger);
    streamHandler.setForegroundLocationService(mockForegroundLocationService);
    streamHandler.setActivity(mockActivity);
    streamHandler.onListen(new HashMap<String, Object>(), mockEventSink);

    verify(mockMessenger).setMessageHandler(eq(CHANNEL_NAME), notNull());
    verify(mockGeolocationManager)
        .startPositionUpdates(eq(mockLocationClient), eq(mockActivity), any(), any());
    return streamHandler;
  }
}
