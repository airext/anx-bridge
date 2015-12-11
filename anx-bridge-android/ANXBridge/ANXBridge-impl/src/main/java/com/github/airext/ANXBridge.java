package com.github.airext;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREExtension;

/**
 * Created by mobitile on 12/11/15.
 */
public class ANXBridge implements FREExtension
{
    @Override
    public void initialize()
    {

    }

    @Override
    public FREContext createContext(String s)
    {
        return new ANXBridgeContext();
    }

    @Override
    public void dispose()
    {

    }
}
