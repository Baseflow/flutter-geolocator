package com.baseflow.geolocator.location;

import static org.junit.Assert.assertEquals;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.inOrder;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.verifyNoInteractions;
import static org.mockito.Mockito.when;

import android.content.Context;
import android.content.pm.PackageManager;
import android.location.GnssStatus;
import android.location.LocationManager;
import android.location.OnNmeaMessageListener;
import android.os.Handler;

import java.util.ArrayDeque;
import java.util.Queue;
import java.util.concurrent.Executor;
import org.junit.Before;
import org.junit.Test;
import org.mockito.InOrder;

public class NmeaClientTest {
  /** Stands in for the NMEA thread: queues work until the test runs it. */
  private static final class QueueExecutor implements Executor {
    final Queue<Runnable> tasks = new ArrayDeque<>();

    @Override
    public void execute(Runnable task) {
      tasks.add(task);
    }

    void runAll() {
      while (!tasks.isEmpty()) {
        tasks.remove().run();
      }
    }
  }

  private Context context;
  private LocationManager locationManager;
  private QueueExecutor executor;
  private NmeaClient client;

  @Before
  public void setUp() {
    context = mock(Context.class);
    locationManager = mock(LocationManager.class);
    when(context.getSystemService(Context.LOCATION_SERVICE)).thenReturn(locationManager);
    when(context.checkSelfPermission(anyString())).thenReturn(PackageManager.PERMISSION_GRANTED);
    executor = new QueueExecutor();
    client =
        new NmeaClient(
            context,
            LocationOptions.parseArguments(null),
            executor,
            /* callbackHandler= */ null,
            /* nmeaSupported= */ true);
  }

  @Test
  public void startMakesNoBinderCallOnTheCallingThread() {
    client.start();

    verifyNoInteractions(locationManager);
    assertEquals(1, executor.tasks.size());

    executor.runAll();
    verify(locationManager)
        .addNmeaListener(any(OnNmeaMessageListener.class), (Handler) any());
    verify(locationManager)
        .registerGnssStatusCallback(any(GnssStatus.Callback.class), (Handler) any());
  }

  @Test
  public void stopMakesNoBinderCallOnTheCallingThread() {
    client.start();
    executor.runAll();

    client.stop();

    verify(locationManager, never()).removeNmeaListener(any(OnNmeaMessageListener.class));
    executor.runAll();
    verify(locationManager).removeNmeaListener(any(OnNmeaMessageListener.class));
    verify(locationManager).unregisterGnssStatusCallback(any(GnssStatus.Callback.class));
  }

  @Test
  public void registrationAndRemovalRunInCallOrder() {
    client.start();
    client.stop();
    client.start();
    executor.runAll();

    InOrder order = inOrder(locationManager);
    order.verify(locationManager)
        .addNmeaListener(any(OnNmeaMessageListener.class), (Handler) any());
    // The last call was start(), so the listener stays registered.
    verify(locationManager, never()).removeNmeaListener(any(OnNmeaMessageListener.class));
  }

  @Test
  public void stopBeforeTheQueuedStartRunsRegistersNothing() {
    client.start();
    client.stop();
    executor.runAll();

    verify(locationManager, never())
        .addNmeaListener(any(OnNmeaMessageListener.class), (Handler) any());
    verify(locationManager, never()).removeNmeaListener(any(OnNmeaMessageListener.class));
  }

  @Test
  public void withoutFineLocationPermissionNothingIsRegistered() {
    when(context.checkSelfPermission(anyString())).thenReturn(PackageManager.PERMISSION_DENIED);

    client.start();
    executor.runAll();

    verify(locationManager, never())
        .addNmeaListener(any(OnNmeaMessageListener.class), (Handler) any());
  }
}
