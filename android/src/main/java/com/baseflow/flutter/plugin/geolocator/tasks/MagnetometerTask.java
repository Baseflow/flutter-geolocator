package com.baseflow.flutter.plugin.geolocator.tasks;

import android.content.Context;
import android.location.Address;
import android.location.Geocoder;

import com.baseflow.flutter.plugin.geolocator.data.AddressMapper;
import com.baseflow.flutter.plugin.geolocator.data.Result;

import java.io.IOException;
import java.util.List;

import io.flutter.plugin.common.PluginRegistry;

class MagnetometerTask extends Task implements SensorEventListener {
    private final Context mContext;

    private SensorManager sensorManager;
    Sensor mSensor; // Magnetic sensor returned by sensor manager

    float x; // magnetometer x value
    float y; // magnetometer y value
    float z; // magnetometer z value
    float magnitude; // magnetometer calculated magnitude

    public MagnetometerTask(TaskContext context) {
        super(context);

        PluginRegistry.Registrar registrar = context.getRegistrar();
        mContext = registrar.activity() != null ? registrar.activity() : registrar.activeContext();
    }

    SensorManager getSensorManager() {
        Context context = mContext;
        return (SensorManager) context.getSystemService(Context.SENSOR_SERVICE);
    }

    @Override
    public void startTask() {

        sensorManager = getSensorManager();
        List<Sensor> list = sensorManager.getSensorList(Sensor.TYPE_MAGNETIC_FIELD);

        // If found, then register as listener
        if (list != null && list.size() > 0) {
            mSensor = list.get(0);
            sensorManager.registerListener(this, mSensor, SensorManager.SENSOR_DELAY_NORMAL);
        }
    }

    public void onSensorChanged(SensorEvent event) {
        this.x = event.values[0];
        this.y = event.values[1];
        this.z = event.values[2];
        this.magnitude = Math.sqrt(x2 + y2 + z2);
        //TODO: Send to flutter
    }

    public void onAccuracyChanged(Sensor sensor, int accuracy) {
        // Do nothing
    }
}
