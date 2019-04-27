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

    Rem
    returns: Null if character not found, CTCharacter otherwise.
    End Rem
    Method CharacterWithID:CTCharacter(characterID:Int)
        For Local character:CTCharacter = EachIn _characters
            If character.GetID() = characterID Then Return character
        Next
        Return Null
    End Method
End Type
