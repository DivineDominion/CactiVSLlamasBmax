SuperStrict

Global firstResponder:CTResponder = Null

Interface CTResponder
    Method KeyUp(key:Int)
    Method MakeFirstResponder()
End Interface

AddHook EmitEventHook, HandleKeyboardInput

Function HandleKeyboardInput:Object(id:Int, data:Object, context:Object)
    If Not firstResponder
        Return data
    End If

    Local event:TEvent = TEvent(data)
    Select event.ID
    Case EVENT_KEYUP
        firstResponder.KeyUp(event.Data)
    End Select
    Return data
End Function
