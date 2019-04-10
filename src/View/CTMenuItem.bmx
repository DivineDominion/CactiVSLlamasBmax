SuperStrict

Type CTMenuItem
    Public
    Field label:String
    Field isDivider:Int = False

    Function Create:CTMenuItem(label:String)
        Local item:CTMenuItem = New CTMenuItem
        item.label = label
        If label.length = 0 Then item.isDivider = True
        Return item
    End Function

    Method IsSkippable:Int()
        Return Self.isDivider
    End Method
End Type
