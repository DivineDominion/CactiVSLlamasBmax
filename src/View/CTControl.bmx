SuperStrict

Import "CTView.bmx"
Import "CTResponder.bmx"
Import "CTKeyInterpreter.bmx"

Type CTControl Extends CTView Implements CTResponder, CTKeyInterpreter
    Method Use(); End Method

    '#Region CTResponder
    Method MakeFirstResponder()
        PushResponder(Self)
    End Method

    Method ResignFirstResponder()
        If FirstResponder() = Self Then PopFirstResponder()
    End Method

    Rem
    bbdoc: Default implementation calls #InterpretKey.
    EndRem
    Method KeyUp(key:Int)
        Self.InterpretKey(key)
    End Method
    '#End Region

    '#Region CTKeyInterpreter control hooks
    Rem
    bbdoc: Interprets key and calls one of `CTControl`'s action methods: #MoveUp, #MoveDown.
    EndRem
    Method InterpretKey(key:Int)
        Select key
        Case KEY_UP MoveUp()
        Case KEY_DOWN MoveDown()
        Case KEY_LEFT MoveLeft()
        Case KEY_RIGHT MoveRight()
        Case KEY_SPACE, KEY_ENTER ConfirmSelection()
        End Select
    End Method

    Method MoveUp(); End Method
    Method MoveDown(); End Method
    Method MoveLeft(); End Method
    Method MoveRight(); End Method
    Method ConfirmSelection(); End Method
    '#End Region
End Type
