/**
 * Created by Max Rozdobudko on 12/11/14.
 */
package com.github.airext.bridge.core {
import flash.events.StatusEvent;
import flash.external.ExtensionContext;
import flash.utils.getTimer;

public class Call
{
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    public function Call(context:ExtensionContext, id:uint, payload:Object)
    {
        super();

        _id = id;

        this.context = context;
        this.context.addEventListener(StatusEvent.STATUS, context_statusHandler);

        this.payload = payload;
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    private var context:ExtensionContext;

    private var payload:Object;

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

    public function callback(value:Function):Object
    {
        _callback = value;

        return payload;
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

        if (incomingId == _id)
        {
            var value:Object;

            switch (event.code)
            {
                case "ANXBridgeCallResult" :

                    var t:Number = getTimer();

                    value = context.call("ANXBridgeCallGetValue", _id, true);

                    _callback(null, value);

                    trace("ANXBridgeCallGetValue for result took", (getTimer() - t) + "ms", "for callId:", _id, "payload:", value);

                    destroy();

                    break;

                case "ANXBridgeCallNotify" :

                    var t:Number = getTimer();

                    value = context.call("ANXBridgeCallGetValue", _id, false);

                    _callback(null, value);

                    trace("ANXBridgeCallGetValue for notify took", (getTimer() - t) + "ms", "for callId:", _id, "payload:", value);

                    break;

                case "ANXBridgeCallReject" :

                    trace(event.code, "incoming =", incomingId, "stored =", _id);

                    _callback(new Error(context.call("ANXBridgeCallGetError", _id)), null);

                    destroy();

                    break;
            }
        }
    }
}
}
