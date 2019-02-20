package com.github.airext.bridge;

import com.adobe.fre.*;

/**
 * Created by mobitile on 12/10/15.
 */
public interface Call
{
    void result(Object value);

    void reject(String cause);

    FREObject toFREObject() throws FREWrongThreadException, FREASErrorException, FREInvalidObjectException, FRENoSuchNameException, FRETypeMismatchException, FREReadOnlyException;
}
