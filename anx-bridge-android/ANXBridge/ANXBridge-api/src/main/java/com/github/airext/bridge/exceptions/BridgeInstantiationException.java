package com.github.airext.bridge.exceptions;

/**
 * Created by mobitile on 12/10/15.
 */
public class BridgeInstantiationException extends Exception
{
    public BridgeInstantiationException(Exception cause)
    {
        _cause = cause;
    }

    private Exception _cause;

    public Exception getCause()
    {
        return _cause;
    }
}
