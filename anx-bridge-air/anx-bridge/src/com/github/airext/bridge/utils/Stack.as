/**
 * Created by max.rozdobudko@gmail.com on 11/20/16.
 */
package com.github.airext.bridge.utils
{
import com.github.airext.bridge.core.Call;
import com.github.airext.bridge.core.bridge_internal;

use namespace bridge_internal;

public class Stack
{
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    public function Stack()
    {
        super();
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    private var callStack:Array = [];

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    bridge_internal function remove(call:Call):void
    {
        callStack[call.id] = null;
    }

    bridge_internal function obtain(id:uint):Call
    {
        return callStack[id];
    }

    bridge_internal function hasCalls():Boolean
    {
        for (var i:int = 0, n:int = callStack.length; i < n; i++)
        {
            if (callStack[i])
                return true;
        }

        return false;
    }
}
}
