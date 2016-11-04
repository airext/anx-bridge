package com.github.airext.bridge.impl;

import android.graphics.Bitmap;
import android.support.annotation.Nullable;
import android.util.Log;
import com.adobe.fre.FREArray;
import com.adobe.fre.FREBitmapData;
import com.adobe.fre.FREObject;
import com.github.airext.bridge.CallResultValue;

import java.lang.reflect.Method;
import java.util.List;

/**
 * Created by max on 11/3/16.
 */

public class ConversionRoutines
{
    @Nullable
    public static FREObject toFREObject(Object value)
    {
        if (value instanceof Iterable)
        {
            List list = (List) value;

            try
            {
                FREArray result = FREArray.newArray(list.size());

                for (int i = 0; i < list.size(); i++)
                {
                    Object item = list.get(i);

                    result.setObjectAt(i, convert(item));
                }

                return result;
            }
            catch (Throwable e)
            {
                e.printStackTrace();
            }

            return null;
        }
        else
        {
            return convert(value);
        }
    }

    @Nullable
    private static FREObject convert(Object value)
    {
        if (value instanceof FREObject)
        {
            return  (FREObject) value;
        }
        else if (value instanceof CallResultValue)
        {
            try
            {
                return ((CallResultValue) value).toFREObject();
            }
            catch (Exception e)
            {
                e.printStackTrace();
            }
        }
        else if (value instanceof Bitmap)
        {
            long t = System.nanoTime();

            Bitmap bitmap = (Bitmap) value;

            Byte[] fillColor = {0,0,0,0};

            try
            {
                FREBitmapData bmd = FREBitmapData.newBitmapData(bitmap.getWidth(), bitmap.getHeight(), true, fillColor);

                bmd.acquire();
                bitmap.copyPixelsToBuffer(bmd.getBits());
                bmd.release();

                Log.i("ANXBridge", ">>>".concat(String.valueOf(System.nanoTime() - t)));

                return bmd;
            }
            catch (Throwable e)
            {
                e.printStackTrace();
            }
        }
        else if (value != null)
        {
            try
            {
                Method toFREObject = value.getClass().getMethod("toFREObject");

                if (toFREObject != null)
                {
                    return (FREObject) toFREObject.invoke(value);
                }
            }
            catch (Exception e)
            {
                e.printStackTrace();
            }
        }

        return null;
    }
}
