package com.github.airext.bridge.impl;

import android.util.Log;
import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.adobe.fre.FREWrongThreadException;
import com.github.airext.bridge.Bridge;
import com.github.airext.bridge.Call;

import java.util.HashMap;
import java.util.Map;

/**
 * Created by mobitile on 12/10/15.
 */
public class BridgeImpl extends Bridge
{
    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------

    private static final int MAX_QUEUE_LENGTH = 1000000;

    private static int currentQueueIndex = 0;

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    protected Map<Integer, Call> asyncCallQueue;

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    //------------------------------------------
    //  Methods: Bridge
    //------------------------------------------

    @Override
    protected void internalSetup(Map<String, FREFunction> functions)
    {
        functions.put("ANXBridgeCallGetValue", new CallGetValueFunction());
        functions.put("ANXBridgeCallGetError", new CallGetErrorFunction());
    }

    @Override
    protected Call internalCall(FREContext context)
    {
        if (asyncCallQueue == null)
            asyncCallQueue = new HashMap<Integer, Call>();

        if (currentQueueIndex > MAX_QUEUE_LENGTH)
            currentQueueIndex = 0;

        Integer callId = currentQueueIndex++;

        CallImpl call = new CallImpl(context, callId, this);

        asyncCallQueue.put(callId, call);

        return call;
    }

    @Override
    protected Call internalObtain(int callId) {
        if (asyncCallQueue != null) {
            return asyncCallQueue.get(callId);
        } else {
            return null;
        }
    }

    //------------------------------------------
    //  Methods: Internal
    //------------------------------------------

    Call obtain(int callId) {
        if (asyncCallQueue != null) {
            return asyncCallQueue.get(callId);
        } else {
            return null;
        }
    }

    void remove(Call call) {
        if (asyncCallQueue != null) {
            asyncCallQueue.remove(call.getCallId());
        }
    }

    //--------------------------------------------------------------------------
    //
    //  Inner classes
    //
    //--------------------------------------------------------------------------

    class CallGetValueFunction implements FREFunction
    {
        @Override
        public FREObject call(FREContext context, FREObject[] args)
        {
            FREObject result = null;

            if (args.length > 0)
            {
                int incomingCallId;
                Boolean removeAfterGet;

                try
                {
                    incomingCallId = args[0].getAsInt();
                    removeAfterGet = args[1].getAsBool();
                }
                catch (Exception e)
                {
                    e.printStackTrace();

                    return null;
                }

                Log.d("ANXBridge", "Retrieving call for result with id: '" + String.valueOf(incomingCallId) + "'");

                CallImpl call = (CallImpl) obtain(incomingCallId);
                if (call != null) {
                    if (removeAfterGet) {
                        Object successResult = call.getResultValue();
                        result = ConversionRoutines.toFREObject(successResult);
                        remove(call);
                    } else {
                        Object mediateResult = call.getNotifyValue();
                        result = ConversionRoutines.toFREObject(mediateResult);
                    }
                }

                if (call != null)
                {
                    Object value = call.getResultValue();

                    result = ConversionRoutines.toFREObject(value);
                }
                else
                {
                    Log.e("ANXBridge", "Can't retrieve call with id: '" + String.valueOf(incomingCallId) + "'");
                }
            }

            return result;
        }
    }

    class CallGetErrorFunction implements FREFunction
    {
        @Override
        public FREObject call(FREContext context, FREObject[] args)
        {
            FREObject result = null;

            if (args.length > 0)
            {
                int callId;

                try
                {
                    callId = args[0].getAsInt();
                }
                catch (Exception e)
                {
                    e.printStackTrace();

                    return null;
                }

                Log.d("ANXBridge", "Retrieving call for error with id: '" + String.valueOf(callId) + "'");

                CallImpl call = (CallImpl) obtain(callId);

                if (call != null)
                {
                    String errorMessage = call.getErrorString();

                    try
                    {
                        result = FREObject.newObject(errorMessage);
                    }
                    catch (FREWrongThreadException e)
                    {
                        e.printStackTrace();
                    }

                    remove(call);
                }
                else
                {
                    Log.e("ANXBridge.Log.Fatal", "Can't retrieve call with id: '" + String.valueOf(callId) + "'");
                }
            }

            return result;
        }
    }
}