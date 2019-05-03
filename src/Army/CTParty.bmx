SuperStrict

Import "CTCharacter.bmx"
Import "../Event.bmx"

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

    Method Contains:Int(character:CTCharacter)
        Return Self._characters.Contains(character)
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

    Method OnCharacterDidDie(character:CTCharacter)
        If Not Self.Contains(character) Then Return
        AnnihilatePartyIfNecessary()
    End Method


    '#Region Party Annihilation
    Private
    Field _isAnnihilated:Int = False

    Public
    Method IsAnnihilated:Int()
        Return _isAnnihilated
    End Method

    Private
    Method AnnihilatePartyIfNecessary()
        If Not Self.ShouldBeAnnihilated() Then Return
        _isAnnihilated = True
        Fire("PartyWasAnnihilated", Self)
    End Method

    Rem
    returns: True only if the party isn't already annihilated, and all characters are dead.
    End Rem
    Method ShouldBeAnnihilated:Int()
        If _isAnnihilated Then Return False
        For Local character:CTCharacter = EachIn Self._characters
            If character.IsAlive() Then Return False
        Next
        Return True
    End Method
    '#End Region
End Type
