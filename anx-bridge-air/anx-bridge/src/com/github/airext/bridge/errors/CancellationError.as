/**
 * Created by max.rozdobudko@gmail.com on 11/14/16.
 */
package com.github.airext.bridge.errors
{
public class CancellationError extends Error
{
    public function CancellationError(reason:Object)
    {
        super(reason);
    }
}
}
