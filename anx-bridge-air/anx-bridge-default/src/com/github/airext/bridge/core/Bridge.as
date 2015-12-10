/**
 * Created by Max Rozdobudko on 12/11/14.
 */
package com.github.airext.bridge.core {
import flash.external.ExtensionContext;
import flash.system.Capabilities;

public class Bridge
{
    //--------------------------------------------------------------------------
    //
    //  Class methods
    //
    //--------------------------------------------------------------------------

    public static function get(context:ExtensionContext):Bridge
    {
        trace("ANXBridge is not supported for " + Capabilities.os);

        return null;
    }

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    public function Bridge(context:ExtensionContext)
    {
        super();

        trace("ANXBridge is not supported for " + Capabilities.os);
    }

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    //-------------------------------------
    //  Methods: Public API
    //-------------------------------------

    public function call(method:String, ...rest):Call
    {
        trace("ANXBridge is not supported for " + Capabilities.os);

        return null;
    }

    //-------------------------------------
    //  Methods: Internal
    //-------------------------------------

    internal function remove(call:Call):void
    {
        trace("ANXBridge is not supported for " + Capabilities.os);
    }

    internal function obtain(id:uint):Call
    {
        trace("ANXBridge is not supported for " + Capabilities.os);

        return null;
    }

    internal function hasCalls():Boolean
    {
        trace("ANXBridge is not supported for " + Capabilities.os);

        return false;
    }
}
}
