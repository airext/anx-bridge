package com.github.airext.bridge.impl;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREObject;
import com.adobe.fre.FREWrongThreadException;
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

    public CallImpl(FREContext context, int callId)
    {
        this.context = context;
        this.callId = callId;
    }

    //-------------------------------------------------------------------------
    //
    //  Variables
    //
    //-------------------------------------------------------------------------

    protected FREContext context;

    protected int callId;

    //-------------------------------------------------------------------------
    //
    //  Properties
    //
    //-------------------------------------------------------------------------

    //------------------------------------
    //  resultValue
    //------------------------------------

    Object resultValue;

    public Object getResultValue()
    {
        return resultValue;
    }

    //------------------------------------
    //  errorString
    //------------------------------------

    String errorString;

    public String getErrorString()
    {
        return errorString;
    }

    //-------------------------------------------------------------------------
    //
    //  Methods
    //
    //-------------------------------------------------------------------------

    @Override
    public void result(Object value)
    {
        resultValue = value;

        context.dispatchStatusEventAsync("ANXBridgeCallResult", Integer.toString(callId));
    }

    @Override
    public void reject(String cause)
    {
        errorString = cause;

        context.dispatchStatusEventAsync("ANXBridgeCallReject", Integer.toString(callId));
    }

    @Override
    public FREObject toFREObject() throws FREWrongThreadException
    {
        return FREObject.newObject(callId);
    }
}
