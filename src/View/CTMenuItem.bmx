SuperStrict

Type CTMenuItem
    Public
    Field label:String
    Field isPlaceholder:Int = False

    Function Create:CTMenuItem(label:String)
        Local item:CTMenuItem = New CTMenuItem
        item.label = label
        If label.length = 0 Then item.isPlaceholder = True
        Return item
    End Function

    Method IsSkippable:Int()
        Return Self.isPlaceholder
    End Method
End Type
