package com.baseflow.geolocator.permission;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.mockStatic;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.times;
import static org.mockito.Mockito.verify;

import android.app.Activity;
import android.util.Log;

import com.baseflow.geolocator.errors.ErrorCallback;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import org.mockito.Mock;
import org.mockito.MockedStatic;
import org.mockito.MockitoAnnotations;

import java.lang.reflect.Constructor;
import java.lang.reflect.Field;

public class PermissionManagerTest {
  private static final int PERMISSION_REQUEST_CODE = 109;

  @Mock Activity mockActivity;
  @Mock PermissionResultCallback mockResultCallback;
  @Mock ErrorCallback mockErrorCallback;
  AutoCloseable mockCloseable;
  // android.util.Log is a stub in local unit tests and throws unless it is mocked.
  MockedStatic<Log> mockLog;
  MockedStatic<PermissionUtils> mockPermissionUtils;

  @Before
  public void setUp() {
    mockCloseable = MockitoAnnotations.openMocks(this);
    mockLog = mockStatic(Log.class);
    mockPermissionUtils = mockStatic(PermissionUtils.class);
    mockPermissionUtils
        .when(() -> PermissionUtils.hasPermissionInManifest(any(), anyString()))
        .thenReturn(true);
  }

  @After
  public void tearDown() throws Exception {
    mockPermissionUtils.close();
    mockLog.close();
    mockCloseable.close();
  }

  @Test
  public void onRequestPermissionsResult_whenResultsAreEmpty_completesPendingRequest()
      throws Exception {
    // Arrange
    PermissionManager permissionManager = createPermissionManagerWithPendingRequest();

    // Act
    permissionManager.onRequestPermissionsResult(
        PERMISSION_REQUEST_CODE, new String[0], new int[0]);

    // Assert
    verify(mockResultCallback).onResult(any());
    verify(mockErrorCallback, never()).onError(any());
  }

  @Test
  public void onRequestPermissionsResult_whenResultsAreEmptyTwice_completesPendingRequestOnce()
      throws Exception {
    // Arrange
    PermissionManager permissionManager = createPermissionManagerWithPendingRequest();

    // Act
    permissionManager.onRequestPermissionsResult(
        PERMISSION_REQUEST_CODE, new String[0], new int[0]);
    permissionManager.onRequestPermissionsResult(
        PERMISSION_REQUEST_CODE, new String[0], new int[0]);

    // Assert
    verify(mockResultCallback, times(1)).onResult(any());
  }

  // Build.VERSION.SDK_INT is 0 in local unit tests, so requestPermission() completes right away
  // without storing the pending request.
  private PermissionManager createPermissionManagerWithPendingRequest() throws Exception {
    Constructor<PermissionManager> constructor = PermissionManager.class.getDeclaredConstructor();
    constructor.setAccessible(true);
    PermissionManager permissionManager = constructor.newInstance();
    setField(permissionManager, "activity", mockActivity);
    setField(permissionManager, "resultCallback", mockResultCallback);
    setField(permissionManager, "errorCallback", mockErrorCallback);
    return permissionManager;
  }

  private static void setField(Object target, String name, Object value) throws Exception {
    Field field = target.getClass().getDeclaredField(name);
    field.setAccessible(true);
    field.set(target, value);
  }
}
