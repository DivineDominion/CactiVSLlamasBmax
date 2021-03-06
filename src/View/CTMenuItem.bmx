SuperStrict

Type CTMenuItem
    Public
    Const NO_OBJECT:Int = -1

    Rem
    bbdoc: ID of a represented object. May be -1 for no representation.
    End Rem
    Field objectID:Int = NO_OBJECT

    Rem
    bbdoc: Text representation in the menu.
    End Rem
    Field label:String = ""
    Field isDivider:Int = False
    Field isEnabled:Int = True
    Field isChecked:Int = False

    Method New(label:String, objectID:Int = -1)
        Self.label = label
        Self.objectID = objectID
        If Not label Or label.length = 0 Then Self.isDivider = True
    End Method

    Function CreateDivider:CTMenuItem()
        Return New CTMenuItem(Null, -1)
    End Function

    Method IsSkippable:Int()
        Return Self.isDivider Or Not Self.isEnabled
    End Method
End Type
