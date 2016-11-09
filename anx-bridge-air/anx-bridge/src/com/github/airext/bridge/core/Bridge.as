/**
 * Created by Max Rozdobudko on 12/11/14.
 */
package com.github.airext.bridge.core {
import flash.external.ExtensionContext;
import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;
import flash.utils.Dictionary;

public class Bridge
{
    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------

    private static const EXTENSION_ID:String = "com.github.airext.Bridge";

    //--------------------------------------------------------------------------
    //
    //  Class variables
    //
    //--------------------------------------------------------------------------

    private static var map:Dictionary = new Dictionary(true);

    //--------------------------------------------------------------------------
    //
    //  Class methods
    //
    //--------------------------------------------------------------------------

    //-------------------------------------
    //  isSupported
    //-------------------------------------

    public function isSupported():Boolean
    {
        return extensionVersion() != null;
    }

    //-------------------------------------
    //  extensionVersion
    //-------------------------------------

    private static var _extensionVersion:String = null;

    /**
     * Returns version of extension
     * @return extension version
     */
    public static function extensionVersion():String
    {
        if (_extensionVersion == null)
        {
            try
            {
                var extension_xml:File = ExtensionContext.getExtensionDirectory(EXTENSION_ID).resolvePath("META-INF/ANE/extension.xml");

                if (extension_xml.exists)
                {
                    var stream:FileStream = new FileStream();
                    stream.open(extension_xml, FileMode.READ);

                    var extension:XML = new XML(stream.readUTFBytes(stream.bytesAvailable));
                    stream.close();

                    var ns:Namespace = extension.namespace();

                    _extensionVersion = extension.ns::versionNumber;
                }
            }
            catch (error:Error)
            {
                // ignore
            }
        }

        return _extensionVersion;
    }

    //-------------------------------------
    //  Getting bridge
    //-------------------------------------

    public static function get(context:ExtensionContext):Bridge
    {
        if (!(context in map))
            map[context] = new Bridge(context);

        return map[context];
    }

    private static function remove(context:ExtensionContext):void
    {
        map[context] = null;
        delete map[context];
    }

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    public function Bridge(context:ExtensionContext)
    {
        super();

        trace("Bridge");

        this.context = context;
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    private var context:ExtensionContext;

    private var callStack:Array = [];

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
        rest.unshift(method);

        var id:uint = context.call.apply(null, rest);

        callStack[id] = call;

        return new Call(context, id);
    }

    //-------------------------------------
    //  Methods: Internal
    //-------------------------------------

    internal function remove(call:Call):void
    {
        callStack[call.id] = null;

        if (!hasCalls())
        {
            Bridge.remove(context);
        }
    }

    internal function obtain(id:uint):Call
    {
        return callStack[id];
    }

    internal function hasCalls():Boolean
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
