SuperStrict

Type CTMenuItem
    Public
    Field label:String

    Function Create:CTMenuItem(label:String)
        Local item:CTMenuItem = New CTMenuItem
        item.label = label
        Return item
    End Function
End Type
