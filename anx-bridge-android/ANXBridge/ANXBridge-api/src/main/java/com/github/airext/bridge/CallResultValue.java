package com.github.airext.bridge;

import com.adobe.fre.FREInvalidObjectException;
import com.adobe.fre.FREObject;
import com.adobe.fre.FRETypeMismatchException;
import com.adobe.fre.FREWrongThreadException;

/**
 * Created by mobitile on 12/11/15.
 */
public interface CallResultValue
{
    FREObject toFREObject() throws FRETypeMismatchException, FREInvalidObjectException, FREWrongThreadException, IllegalStateException;
}
