package com.github.airext.bridge
{
import com.github.airext.bridge.core.Bridge;

import flash.system.Capabilities;

public function bridge(context:Object):Bridge
    {
        trace("ANXBridge is not supported for " + Capabilities.os);

        return null;
    }
}