SuperStrict

Import "Logging/CTDisplayLog.bmx"
Import "Logging/CTLogView.bmx"
Import "View/CTWindow.bmx"

Global mainLog:CTDisplayLog = CTDisplayLog.Create()

AddHook EmitEventHook, LogEventToMainLog

Function LogEventToMainLog:Object(id:Int, data:Object, context:Object)
    Local event:TEvent = TEvent(data)
    mainLog.Append(event.ToString())
    Return data
End Function

Function CreateLogWindow:CTWindow(log:CTDisplayLog)
    Local logView:CTLogView = CTLogView.Create(log)
    Return CTWindow.Create(0, 0, 400, TextHeight("x") * 3, logView)
End Function
