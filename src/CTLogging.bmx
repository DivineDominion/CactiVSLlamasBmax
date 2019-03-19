SuperStrict

import "CTDisplayLog.bmx"

Global displayLog:CTDisplayLog = CTDisplayLog.Create()

AddHook EmitEventHook, LogEvent

Function LogEvent:Object(id:Int, data:Object, context:Object)
    Local event:TEvent = TEvent(data)
    displayLog.Append(event.ToString())
    Return data
End Function
