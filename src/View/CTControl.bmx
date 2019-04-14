SuperStrict

Import "CTView.bmx"
Import "CTResponder.bmx"
Import "CTKeyInterpreter.bmx"

Type CTControl Extends CTView Implements CTResponder, CTKeyInterpreter
    Field consumesKeyEvents:Int = True

    Rem
    Set the `keyInterpreterDelegate` to implement event handling on a controller
    object instead of the view/control itself.
    End Rem
    Field keyInterpreterDelegate:CTKeyInterpreter = Null

    Method TearDown()
        RemoveFromResponderStack()
        RemoveKeyInterpreterDelegate() ' Break eventual retain cycles
    End Method


    '#Region CTResponder
    Method MakeFirstResponder()
        PushResponder(Self)
    End Method

    Method ResignFirstResponder()
        If IsFirstResponder(Self) Then PopFirstResponder()
    End Method

    Method RemoveFromResponderStack()
        RemoveResponder(Self)
    End Method

    Rem
    bbdoc: Default implementation calls #InterpretKey.
    returns: `consumesKeyEvents`, False by default.
    EndRem
    Method KeyDown:Int(key:Int)
        Self.InterpretKey(key)
        Return Self.consumesKeyEvents
    End Method
    '#End Region


    '#Region CTKeyInterpreter control hooks
    Method RemoveKeyInterpreterDelegate()
        Self.keyInterpreterDelegate = Null
    End Method

    Rem
    bbdoc: Interprets key and calls one of `CTKeyInterpreter`'s action methods, delegating to `keyInterpreterDelegate` if set.
    EndRem
    Method InterpretKey(key:Int)
        Select key
        Case KEY_UP MoveUp()
        Case KEY_DOWN MoveDown()
        Case KEY_LEFT MoveLeft()
        Case KEY_RIGHT MoveRight()
        Case KEY_SPACE, KEY_ENTER ConfirmSelection()
        Case KEY_ESCAPE Cancel()
        End Select
    End Method

    Method MoveUp()
        If Self.keyInterpreterDelegate Then keyInterpreterDelegate.MoveUp()
    End Method

    Method MoveDown()
        If Self.keyInterpreterDelegate Then keyInterpreterDelegate.MoveDown()
    End Method

    Method MoveLeft()
        If Self.keyInterpreterDelegate Then keyInterpreterDelegate.MoveLeft()
    End Method

    Method MoveRight()
        If Self.keyInterpreterDelegate Then keyInterpreterDelegate.MoveRight()
    End Method

    Method ConfirmSelection()
        If Self.keyInterpreterDelegate Then keyInterpreterDelegate.ConfirmSelection()
    End Method

    Method Cancel()
        If Self.keyInterpreterDelegate Then keyInterpreterDelegate.Cancel()
    End Method
    '#End Region
End Type
