/**
 * Created by Max Rozdobudko on 12/11/14.
 */
package com.github.airext.bridge.core {
import flash.events.StatusEvent;
import flash.external.ExtensionContext;

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

        _id = id;

        this.context = context;
        this.context.addEventListener(StatusEvent.STATUS, context_statusHandler);
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    private var context:ExtensionContext;

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //-------------------------------------
    //  id
    //-------------------------------------

    private var _id:uint;

    public function get id():uint
    {
        return _id;
    }

    //--------------------------------------------------------------------------
    //
    //  Setters
    //
    //--------------------------------------------------------------------------

    //-------------------------------------
    //  callback
    //-------------------------------------

    private var _callback:Function;

    public function callback(value:Function):void
    {
        _callback = value;
    }

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    protected function destroy():void
    {
        context.removeEventListener(StatusEvent.STATUS, context_statusHandler);

        Bridge.get(context).remove(this);
    }

    //--------------------------------------------------------------------------
    //
    //  Event handlers
    //
    //--------------------------------------------------------------------------

    private function context_statusHandler(event:StatusEvent):void
    {
        var incomingId:int = parseInt(event.level);

        trace(event.code, incomingId, id);

        if (incomingId == _id)
        {
            switch (event.code)
            {
                case "ANXBridgeCallResult" :

                    _callback(null, context.call("ANXBridgeCallGetValue", _id));

                    destroy();

                    break;

                case "ANXBridgeCallReject" :

                    _callback(new Error(context.call("ANXBridgeCallGetError", _id)), null);

                    destroy();

                    break;
            }
        }
    }
}
}
