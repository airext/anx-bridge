package com.github.airext.bridge
{
import com.github.airext.bridge.core.Bridge;

import flash.external.ExtensionContext;

    public function bridge(context:ExtensionContext):Bridge
    {
        return Bridge.get(context);
    }
}