package com.github.airext.bridge;

import android.support.annotation.Nullable;
import com.adobe.fre.FREObject;
import com.adobe.fre.FREWrongThreadException;

/**
 * Created by mobitile on 12/10/15.
 */
public interface Call
{
    public int getCallId();

    void result(Object value);

    void notify(Object value);

    void reject(String cause);

    void cancel();

    @Nullable
    FREObject toFREObject();

    @Nullable
    FREObject toFREObjectWithPayload(FREObject payload);
}
