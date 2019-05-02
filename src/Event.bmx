SuperStrict

Import "Game/CTGameEventDispatcher.bmx"

Function AddListener(obj:Object)
    CTGameEventDispatcher.GetInstance().AddListener(obj)
End Function

Function RemoveListener(obj:Object)
    CTGameEventDispatcher.GetInstance().RemoveListener(obj)
End Function

Function Fire(eventName:String, source:Object, payload:Object = Null)
    CTGameEventDispatcher.GetInstance().Fire(eventName, source, payload)
End Function
