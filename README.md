# anx-bridge

## Overview
This is utility [AIR Native Extension](http://www.adobe.com/devnet/air/native-extensions-for-air.html) that allows to add asynchronous calls to other native extension.

## Setup
Use [com.github.airext.Bridge.swc](https://github.com/airext/anx-bridge/blob/master/bin/com.github.airext.Bridge.swc) library and corresponded headers to build ANE and [com.github.airext.Bridge.ane](https://github.com/airext/anx-bridge/blob/master/bin/com.github.airext.Bridge.ane) for application that uses ANE based on anx-bridge.

### Setup ActionScript project
Just link [com.github.airext.Bridge.swc](https://github.com/airext/anx-bridge/blob/master/bin/anx-bridge.swc) as **external** library.

### Setup Objective-C project
* link corresponded headers to your Xcode [bin/headers/ios](https://github.com/airext/anx-bridge/blob/master/bin/include/ios) for iOS project and [bin/headers/osx](https://github.com/airext/anx-bridge/blob/master/bin/include/osx) for OSX project;
* in ContextInitializer function right **after** function initialization call `[ANXBridge setup:functions:];` as showed next:
```objc
void TSTContextInitializer(void* extData, const uint8_t* ctxType, FREContext ctx, uint32_t* numFunctionsToSet, const FRENamedFunction** functionsToSet)
{
    *numFunctionsToSet = 1;
    
    FRENamedFunction* func = (FRENamedFunction*) malloc(sizeof(FRENamedFunction) * (*numFunctionsToSet));
    
    func[0].name = (const uint8_t*) "isSupported";
    func[0].functionData = NULL;
    func[0].function = &ANXTwitterIsSupported;
    
    [ANXBridge setup:numFunctionsToSet functions:&func];

    *functionsToSet = func;
}
```
this registers additional functions used by anx-bridge.

### Setup Application project
* link [com.github.airext.Bridge.ane](https://github.com/airext/anx-bridge/blob/master/bin/com.github.airext.Bridge.ane) with your project ([more info](http://help.adobe.com/en_US/air/build/WS597e5dadb9cc1e0253f7d2fc1311b491071-8000.html) about linking);
* declare `com.github.airext.Bridge` extension in your applicaton descriptor:
```xml
<extensions> 
    <extensionID>com.github.airext.Bridge</extensionID>
</extensions>
```

## Usage

### ActionScript
Using anx-bridge from ActionScript in one line:
```as3
bridge(context).call("someMethod", arg1, arg2).callback(callback);
```
where:
* `context` is [ExtensionContext](http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/external/ExtensionContext.html);
* `someMethod` is registered function that takes two arguments `arg1` and `arg2`;
* `callback` is function with signature `function(error:Error = null, value:Object = null):void`.

### Objective-C
On objective-c part you use [ANXBridge] class for create async calls and [ANXBridgeCall] class for notify failure or result:
```objc
// creates call
ANXBridgeCall* call = [ANXBridge call:context];

// notify success where value is FREObject received as second argument in callback on AIR side
[call result: value];

// notify failure where error is NSError that will be converted to ActionScript' Error object
[call reject:error];

// each async method should retrun ANXBridgeCall as FREObject
return [call toFREObject];
```

## Example
Asume we implement Twitter login method (this is real example from [fabric/twitter](https://github.com/airext/fabric/tree/master/twitter) kit):

ActionScript part contains one method login:
```as3
public function login(callback:Function):void
{
  bridge(context).call("login").callback(callback);
}
```

Objective-C context initializer:
```objc
void ANXTwitterContextInitializer(void* extData, const uint8_t* ctxType, FREContext ctx, uint32_t* numFunctionsToTest, const FRENamedFunction** functionsToSet)
{
    *numFunctionsToTest = 1;
    
    FRENamedFunction* func = (FRENamedFunction*) malloc(sizeof(FRENamedFunction) * (*numFunctionsToTest));
    
    func[0].name = (const uint8_t*) "login";
    func[0].functionData = NULL;
    func[0].function = &ANXTwitterLogin;
    
    [ANXBridge setup:numFunctionsToTest functions:&func];

    *functionsToSet = func;
}
```

Objective-C context login method:
```objc
FREObject ANXTwitterLogin(FREContext context, void* functionData, uint32_t argc, FREObject argv[])
{
    ANXBridgeCall* call = [ANXBridge call:context];
    
    [[Twitter sharedInstance] logInWithCompletion:
        ^(TWTRSession *session, NSError *error)
        {
            if (session)
            {
              // assume there is method that converts TWTRSession to FREObject
              FREObject freSession = [self convertSessionToFREObject:session];
            
              [call result:freSession];
            }
            else
            {
                [call reject:error];
            }
        }];
    
    return [call toFREObject];
}
```

ActionScript usage in end application:
```as3
Twitter.sharedInstance().login(
  function(error:Error = null, session:Object = null):void
  {
    if (session != null)
    {
      trace("Logged in as:", session.userName);
    }
    else
    {
      trace("Login failed:", String(error));
    }
  }
);
```
