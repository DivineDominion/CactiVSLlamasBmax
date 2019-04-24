SuperStrict

Import "Logging/CTDisplayLog.bmx"
Import "Logging/CTLogView.bmx"
Import "View/CTWindowManager.bmx"

Global mainLog:CTDisplayLog = CTDisplayLog.Create()

AddHook EmitEventHook, LogEventToMainLog
AddHook EmitEventHook, ShowHideLogWindow

Function LogEventToMainLog:Object(id:Int, data:Object, context:Object)
    Local event:TEvent = TEvent(data)
    mainLog.Append(event.ToString())
    Return data
End Function

Function ShowHideLogWindow:Object(id:Int, data:Object, context:Object)
    Local event:TEvent = TEvent(data)

    If event.ID = EVENT_KEYDOWN And event.Data = KEY_TILDE
        If logWindow
            CTWindowManager.GetInstance().RemoveWindow(logWindow)
            logWindow = Null
        Else
            logWindow = CreateLogWindow(mainLog)
            CTWindowManager.GetInstance().AddWindow(logWindow)
        End If
    End If

    Return data
End Function

Private

Global logWindow:CTWindow = Null

Function CreateLogWindow:CTWindow(log:CTDisplayLog)
    Local logView:CTLogView = CTLogView.Create(log)
    Return CTWindow.Create(0, 0, 400, logView.InstrinsicHeight(), logView)
End Function
