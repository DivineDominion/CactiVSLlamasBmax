SuperStrict

Import "CTView.bmx"
Import "CTResponder.bmx"

Type CTControl Extends CTView Implements CTResponder
    Method Use(); End Method

    '#Region CTResponder
    Method MakeFirstResponder()
        firstResponder = Self
    End Method

    Rem
    bbdoc: Default implementation calls #InterpretKey.
    EndRem
    Method KeyUp(key:Int)
        Self.InterpretKey(key)
    End Method
    '#End Region

    '#Region Control hooks
    Rem
    bbdoc: Interprets key and calls one of `CTControl`'s action methods: #MoveUp, #MoveDown.
    EndRem
    Method InterpretKey(key:Int)
        Select key
        Case KEY_UP
            MoveUp()

        Case KEY_DOWN
            MoveDown()
        End Select
    End Method

    Method MoveUp(); End Method
    Method MoveDown(); End Method
    '#End Region
End Type
