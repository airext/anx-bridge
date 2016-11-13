/**
 * Created by Max Rozdobudko on 12/11/14.
 */
package com.github.airext.bridge.core {
import flash.external.ExtensionContext;
import flash.system.Capabilities;

public class Call
{
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    public function Call(context:ExtensionContext, id:uint)
    {
        super();

        trace("ANXBridge is not supported for " + Capabilities.os);
    }

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //-------------------------------------
    //  id
    //-------------------------------------

    public function get id():uint
    {
        trace("ANXBridge is not supported for " + Capabilities.os);

        return null;
    }

    //--------------------------------------------------------------------------
    //
    //  Setters
    //
    //--------------------------------------------------------------------------

    //-------------------------------------
    //  callback
    //-------------------------------------

    public function callback(value:Function):Object
    {
        trace("ANXBridge is not supported for " + Capabilities.os);

        return null;
    }

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    protected function destroy():void
    {
        trace("ANXBridge is not supported for " + Capabilities.os);
    }
}
}
