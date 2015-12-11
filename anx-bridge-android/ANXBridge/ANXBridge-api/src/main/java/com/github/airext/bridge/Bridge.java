package com.github.airext.bridge;

import android.support.annotation.Nullable;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.github.airext.bridge.exceptions.BridgeInstantiationException;
import com.github.airext.bridge.exceptions.BridgeNotFoundException;

import java.util.Map;

/**
 * Created by mobitile on 12/10/15.
 */
public abstract class Bridge
{
    //-------------------------------------------------------------------------
    //
    //  Class variables
    //
    //-------------------------------------------------------------------------

    public static String DEFAULT_IMPLEMENTATION = "com.github.airext.bridge.impl.BridgeImpl";

    //-------------------------------------------------------------------------
    //
    //  Class properties
    //
    //-------------------------------------------------------------------------

    protected static Bridge implementation;

    protected static Bridge getImplementation() throws ClassNotFoundException, IllegalAccessException, InstantiationException
    {
        if (implementation == null)
        {
            Class<?> Impl = Class.forName(DEFAULT_IMPLEMENTATION);

            setImplementation((Bridge) Impl.newInstance());
        }

        return implementation;
    }

    protected static void setImplementation(Bridge value)
    {
        if (implementation == null)
        {
            implementation = value;
        }
    }

    //-------------------------------------------------------------------------
    //
    //  Class methods
    //
    //-------------------------------------------------------------------------

    public static void setup(Map<String, FREFunction> functions) throws BridgeNotFoundException, BridgeInstantiationException
    {
        try
        {
            getImplementation().internalSetup(functions);
        }
        catch (ClassNotFoundException e)
        {
            throw new BridgeNotFoundException();
        }
        catch (Exception e)
        {
            throw new BridgeInstantiationException(e);
        }
    }

    @Nullable
    public static Call call(FREContext context)
    {
        try
        {
            return getImplementation().internalCall(context);
        }
        catch (ClassNotFoundException e)
        {
            e.printStackTrace();
        }
        catch (IllegalAccessException e)
        {
            e.printStackTrace();
        }
        catch (InstantiationException e)
        {
            e.printStackTrace();
        }

        return null;
    }

    //-------------------------------------------------------------------------
    //
    //  Methods
    //
    //-------------------------------------------------------------------------

    abstract protected void internalSetup(Map<String, FREFunction> functions);

    abstract protected Call internalCall(FREContext context);
}
