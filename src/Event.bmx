SuperStrict

Import "Game/CTGameEventDispatcher.bmx"

Function Fire(eventName:String, source:Object, payload:Object = Null)
    CTGameEventDispatcher.GetInstance().Fire(eventName, source, payload)
End Function
