package com.baseflow.flutter.plugin.geolocator.tasks;

import com.baseflow.flutter.plugin.geolocator.OnCompletionListener;

import java.util.UUID;

public abstract class Task {
    private final UUID mTaskID;
    private final TaskContext mTaskContext;

    Task(TaskContext context) {
        mTaskID = UUID.randomUUID();
        mTaskContext = context;
    }

    public UUID getTaskID() {
        return mTaskID;
    }

    TaskContext getTaskContext() {
        return mTaskContext;
    }

    public abstract void startTask();

    public void stopTask() {
        OnCompletionListener completionListener = getTaskContext().getCompletionListener();

        if(completionListener != null) {
            completionListener.onCompletion(getTaskID());
        }
    }
}
