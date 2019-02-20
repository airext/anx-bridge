/**
 * Created by max.rozdobudko@gmail.com on 11/10/16.
 */
package com.github.airext.bridge.utils
{
import com.github.airext.bridge.core.Call;

public class Queue
{
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    public function Queue()
    {
        super();
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    private var callsQueue:Array = [];

    private var callsStack:Array = [];

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    public function schedule(call:Call):void
    {

    }

    public function cancel(call:Call):Boolean
    {
        return false;
    }
}
}
