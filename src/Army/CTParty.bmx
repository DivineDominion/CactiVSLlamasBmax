SuperStrict

Import "CTCharacter.bmx"

Type CTParty
    Private
    Field _characters:TList

    Public
    Method New(characters:TList)
        Self._characters = characters.Copy()
    End Method

    Method Count:Int()
        Return _characters.Count()
    End Method

    Method Characters:CTCharacter[]()
        Return CTCharacter[](_characters.ToArray())
    End Method
End Type
