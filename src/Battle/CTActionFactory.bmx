SuperStrict

Import "CTActionable.bmx"
Import "CTTackleAction.bmx"
Import "../Army/CTCharacter.bmx"

Type CTActionFactory
    Private
    Method New(); End Method

    Public
    Function FighterActionsForCharacter:CTActionable[](character:CTCharacter)
        Return [..
            New CTTackleAction(character)..
        ]
    End Function
End Type
