SuperStrict

Import "CTActionable.bmx"
Import "CTTackleAction.bmx"

Type CTActionFactory
    Private
    Method New(); End Method

    Public
    Function FighterActions:CTActionable[]()
        Return [..
            New CTTackleAction()..
        ]
    End Function
End Type
