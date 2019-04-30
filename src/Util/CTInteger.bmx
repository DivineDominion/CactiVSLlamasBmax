SuperStrict

Type CTInteger
    Field value:Int

    Method New(value:Int)
        Self.value = value
    End Method

    Method ToString:String()
        Return String(Self.value)
    End Method
End Type
