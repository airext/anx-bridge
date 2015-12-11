package com.github.airext.bridge.impl;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.adobe.fre.FREWrongThreadException;
import com.github.airext.bridge.Bridge;
import com.github.airext.bridge.Call;
import com.github.airext.bridge.CallResultValue;

import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.Map;

/**
 * Created by mobitile on 12/10/15.
 */
public class BridgeImpl extends Bridge
{
    //----------------------------------------------------------------------------------------------
    //
    //  Variables
    //
    //----------------------------------------------------------------------------------------------

    protected ArrayList<Call> asyncCallStack;

    //----------------------------------------------------------------------------------------------
    //
    //  Methods
    //
    //----------------------------------------------------------------------------------------------

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
        if (asyncCallStack == null)
            asyncCallStack = new ArrayList<Call>();

        int count = asyncCallStack.size();

        CallImpl call = new CallImpl(context, count);

        asyncCallStack.add(call);

        return call;
    }

    //------------------------------------------
    //  Methods: Internal
    //------------------------------------------

    protected Call retrieve(int callId)
    {
        if (asyncCallStack != null && asyncCallStack.size() > callId)
        {
            Call call = asyncCallStack.remove(callId);

            return call;
        }
        else
        {
            return null;
        }
    }

    //----------------------------------------------------------------------------------------------
    //
    //  Inner classes
    //
    //----------------------------------------------------------------------------------------------

    class CallGetValueFunction implements FREFunction
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

                CallImpl call = (CallImpl) retrieve(callId);

                if (call != null)
                {
                    Object value = call.getResultValue();

                    if (value instanceof  FREObject)
                    {
                        result = (FREObject) value;
                    }
                    else if (value instanceof CallResultValue)
                    {
                        try
                        {
                            result = ((CallResultValue) value).toFREObject();
                        }
                        catch (Exception e)
                        {
                            e.printStackTrace();
                        }
                    }
                    else if (value != null)
                    {
                        try
                        {
                            Method toFREObject = value.getClass().getMethod("toFREObject");

                            if (toFREObject != null)
                            {
                                result = (FREObject) toFREObject.invoke(value);
                            }
                        }
                        catch (Exception e)
                        {
                            e.printStackTrace();
                        }
                    }
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

                CallImpl call = (CallImpl) retrieve(callId);

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
                }
            }

            return result;
        }
    }
}