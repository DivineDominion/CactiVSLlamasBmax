SuperStrict

Type CTMenuItem
    Public
    Rem
    bbdoc: ID of a represented object. May be -1 for no representation.
    End Rem
    Field objectID:Int = -1

    Rem
    bbdoc: Text representation in the menu.
    End Rem
    Field label:String = ""
    Field isDivider:Int = False

    Method New(label:String, objectID:Int = -1)
        Self.label = label
        Self.objectID = objectID
        If Not label Or label.length = 0 Then Self.isDivider = True
    End Method

    Function CreateDivider:CTMenuItem()
        Return New CTMenuItem(Null, -1)
    End Function

    Method IsSkippable:Int()
        Return Self.isDivider
    End Method
End Type
