SuperStrict

Import "CTResponder.bmx"
Import "CTView.bmx"
Import "CTKeyInterpreter.bmx"

Type CTController Implements CTKeyInterpreter Abstract
    Method View:CTView() Abstract

    Method TearDown()
        Self.View().TearDown()
    End Method

    Method MakeFirstResponder()
        Local responder:CTResponder = CTResponder(Self.View())
        If responder Then responder.MakeFirstResponder()
    End Method


    '#Region CTKeyInterpreter
    Method MoveUp(); End Method
    Method MoveDown(); End Method
    Method MoveLeft(); End Method
    Method MoveRight(); End Method
    Method ConfirmSelection(); End Method
    Method Cancel(); End Method
    '#End Region
End Type
