SuperStrict

Interface CTResponder
    Rem
    returns: True if event should be consumed, false if passed on.
    EndRem
    Method KeyDown:Int(key:Int)
    Method MakeFirstResponder()
End Interface

AddHook EmitEventHook, HandleKeyboardInput

Function HandleKeyboardInput:Object(id:Int, data:Object, context:Object)
    Local event:TEvent = TEvent(data)

    DebugLog "Event: " + event.ToString()

    For Local responder:CTResponder = EachIn _responderStack
        DebugLog "Responder: " + TTypeId.ForObject(responder).Name()
        Select event.ID
            Case EVENT_KEYDOWN
                 Local consumed:Int = responder.KeyDown(event.Data)
                 If consumed Then Exit
        End Select
    Next

    Return data
End Function

Function FirstResponder:CTResponder()
    If _responderStack.First() = Null Then Return Null
    Return CTResponder(_responderStack.First())
End Function

Function IsFirstResponder:Int(responder:CTResponder)
    Return FirstResponder() = responder
End Function

Function PushResponder(responder:CTResponder)
    ' Only allow 1 instance in the stack
    RemoveResponder(responder)
    _responderStack.AddFirst(responder)
End Function

Function PopFirstResponder:CTResponder()
    If _responderStack.First() = Null Then Return Null
    Return CTResponder(_responderStack.RemoveFirst())
End Function

Function RemoveResponder(responder:CTResponder)
    _responderStack.Remove(responder)
End Function

Rem
Replaces `responder` with `newResponder` in the stack if both parameters are
present. Removes `responder` at the least, if possible.
EndRem
Function ReplaceResponderWithNewResponder(responder:CTResponder, newResponder:CTResponder)
    If responder = Null Then Return
    Local link:TLink = _responderStack.FindLink(responder)
    If link
        If newResponder <> Null
            _responderStack.InsertBeforeLink(newResponder, link)
        End If
        link.Remove()
    End If
End Function

Private
Global _responderStack:TList = New TList
