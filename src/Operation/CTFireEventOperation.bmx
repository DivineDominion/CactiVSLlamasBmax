SuperStrict

Import "CTOperation.bmx"
Import "../Event.bmx"

Type CTFireEventOperation Extends CTOperation Final
    Private
    Field eventName:String
    Field source:Object
    Field payload:Object

    Method New(); End Method

    Public
    Method New(eventName:String, source:Object, payload:Object = Null)
        Assert eventName Else "CTFireEventOperation requires eventName"
        Assert source Else "CTFireEventOperation requires source"
        Self.eventName = eventName
        Self.source = source
        Self.payload = payload
    End Method

    Method Main:Int()
        Fire(eventName, source, payload)
    End Method
End Type
