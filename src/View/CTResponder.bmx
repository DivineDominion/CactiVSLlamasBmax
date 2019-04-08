SuperStrict


Interface CTResponder
    Method KeyUp(key:Int)
    Method MakeFirstResponder()
End Interface

AddHook EmitEventHook, HandleKeyboardInput

Function HandleKeyboardInput:Object(id:Int, data:Object, context:Object)
    Local responder:CTResponder = FirstResponder()
    If responder <> Null
        Local event:TEvent = TEvent(data)
        Select event.ID
            Case EVENT_KEYUP responder.KeyUp(event.Data)
        End Select
    End If

    Return data
End Function

Function FirstResponder:CTResponder()
    If _responderStack.Last() = Null Then Return Null
    Return CTResponder(_responderStack.Last())
End Function

Function PushResponder(responder:CTResponder)
    _responderStack.AddLast(responder)
End Function

Function PopFirstResponder:CTResponder()
    If _responderStack.Last() = Null Then Return Null
    Return CTResponder(_responderStack.RemoveLast())
End Function

Private
Global _responderStack:TList = New TList
