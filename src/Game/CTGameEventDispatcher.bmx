SuperStrict

Type CTGameEventDispatcher
    Private
    Method New(); End Method
    Field listeners:TList = New TList

    Public
    Function GetInstance:CTGameEventDispatcher()
        If Not _eventDispatcher Then _eventDispatcher = New CTGameEventDispatcher()
        Return _eventDispatcher
    End Function

    Method AddListener(obj:Object)
        Self.listeners.AddLast(obj)
    End Method

    Method RemoveListener(obj:Object)
        Self.listeners.Remove(obj)
    End Method

    Method Fire(eventName:String, source:Object, payload:Object = Null)
        Local callbackName:String = "On" + eventName
        DebugLog("Firing " + eventName)
        For Local listener:Object = EachIn Self.listeners
            Local callback:TMethod = TTypeId.ForObject(listener).FindMethod(callbackName)
            If callback
                If callback.ArgTypes() = Null Or callback.ArgTypes().Length = 1
                    callback.Invoke(listener, [source])
                Else
                    callback.Invoke(listener, [source, payload])
                End If
            End If
        Next
    End Method
End Type

Private
Global _eventDispatcher:CTGameEventDispatcher
