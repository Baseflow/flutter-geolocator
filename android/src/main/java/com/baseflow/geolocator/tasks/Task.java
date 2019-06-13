package com.baseflow.geolocator.tasks;

import androidx.annotation.Nullable;
import com.baseflow.geolocator.OnCompletionListener;

import java.util.UUID;

public abstract class Task<TOptions> {
    private final UUID mTaskID;
    private final TaskContext<TOptions> mTaskContext;

    Task(@Nullable UUID taskID, TaskContext<TOptions> context) {
        if (taskID == null) {
            mTaskID = UUID.randomUUID();
        } else {
            mTaskID = taskID;
        }
        mTaskContext = context;
    }

    public UUID getTaskID() {
        return mTaskID;
    }

    TaskContext<TOptions> getTaskContext() {
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
