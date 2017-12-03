package com.github.airext.bridge.impl;

import android.support.annotation.Nullable;
import com.adobe.fre.*;
import com.github.airext.bridge.Bridge;
import com.github.airext.bridge.Call;

/**
 * Created by mobitile on 12/10/15.
 */
public class CallImpl implements Call
{
    //-------------------------------------------------------------------------
    //
    //  Constructor
    //
    //-------------------------------------------------------------------------

    public CallImpl(FREContext context, int callId, BridgeImpl bridge) {
        super();
        this.context = context;
        this.callId = callId;
        this.bridge = bridge;
    }

    //-------------------------------------------------------------------------
    //
    //  Variables
    //
    //-------------------------------------------------------------------------

    protected FREContext context;
    protected BridgeImpl bridge;

    protected Boolean _isCancelled = false;

    //-------------------------------------------------------------------------
    //
    //  Properties
    //
    //-------------------------------------------------------------------------

    //------------------------------------
    //  callId
    //------------------------------------

    protected int callId;
    public int getCallId() {
        return callId;
    }

    //------------------------------------
    //  resultValue
    //------------------------------------

    Object successValue;
    public Object getResultValue() {
        return successValue;
    }

    //------------------------------------
    //  notifyValue
    //------------------------------------

    Object mediateValue;
    public Object getNotifyValue() {
        return mediateValue;
    }

    //------------------------------------
    //  errorString
    //------------------------------------

    String errorString;
    public String getErrorString() {
        return errorString;
    }

    //-------------------------------------------------------------------------
    //
    //  Methods
    //
    //-------------------------------------------------------------------------

    @Override
    public void result(Object value) {
        if (_isCancelled) return;
        successValue = value;
        context.dispatchStatusEventAsync("ANXBridgeCallResult", Integer.toString(callId));
    }

    @Override
    public void notify(Object value) {
        if (_isCancelled) return;
        mediateValue = value;
        context.dispatchStatusEventAsync("ANXBridgeCallNotify", Integer.toString(callId));
    }

    @Override
    public void reject(String cause) {
        if (_isCancelled) return;
        errorString = cause;
        context.dispatchStatusEventAsync("ANXBridgeCallReject", Integer.toString(callId));
    }

    @Override
    public void cancel() {
        _isCancelled = true;
        mediateValue = null;
        successValue = null;
        errorString = null;
        bridge.remove(this);
        context.dispatchStatusEventAsync("ANXBridgeCallCancel", Integer.toString(callId));
    }

    @Override
    @Nullable
    public FREObject toFREObject() {
        return toFREObjectWithPayload(null);
    }

    @Nullable
    @Override
    public FREObject toFREObjectWithPayload(FREObject payload) {
        try {
            FREObject result = FREObject.newObject("Object", null);
            result.setProperty("id", FREObject.newObject(callId));
            result.setProperty("payload", payload);
            return result;
        } catch (FREWrongThreadException e) {
            e.printStackTrace();
        } catch (FREASErrorException e) {
            e.printStackTrace();
        } catch (FREInvalidObjectException e) {
            e.printStackTrace();
        } catch (FRENoSuchNameException e) {
            e.printStackTrace();
        } catch (FREReadOnlyException e) {
            e.printStackTrace();
        } catch (FRETypeMismatchException e) {
            e.printStackTrace();
        }
        return null;
    }
}
