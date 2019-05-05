SuperStrict

Import "../Event.bmx"
Import "../Army/CTParty.bmx"
Import "../Army/CTCharacter.bmx"
Import "../Battlefield/CTBattlefield.bmx"

Type CTBattle
    ' Map representation of characters as tokens
    Field battlefield:CTBattlefield

    ' Active parties and fighters of this battle
    Field cactusParty:CTParty
    Field llamaParty:CTParty
    Field characters:TIntMap

    Method New(battlefield:CTBattlefield, cactusParty:CTParty, llamaParty:CTParty)
        Self.battlefield = battlefield
        Self.cactusParty = cactusParty
        Self.llamaParty = llamaParty
        Self.characters = CharactersFromParties([cactusParty, llamaParty])
    End Method


    '#Region Battle lifecycle
    Public
    Method StartWithCharacterAnimator(animator:CTCharacterAnimator)
        AddListener(cactusParty)
        AddListener(llamaParty)
        AddListener(battlefield)
        Self.SetCharacterAnimator(animator)
    End Method

    Method Finish()
        Self.SetCharacterAnimator(Null)
        RemoveListener(cactusParty)
        RemoveListener(llamaParty)
        RemoveListener(battlefield)
    End Method

    Private
    Method SetCharacterAnimator(animator:CTCharacterAnimator)
        'DebugLog "Set anim for all " + String(Self.characters.Values().Count())
        For Local character:CTCharacter = EachIn Self.characters.Values()
            character.SetAnimator(animator)
        Next
    End Method
    '#End Region
End Type

Private
Function CharactersFromParties:TIntMap(parties:CTParty[])
    Local result:TIntMap = New TIntMap()
    For Local party:CTParty = EachIn parties
        For Local character:CTCharacter = EachIn party.Characters()
            result.Insert(character.GetID(), character)
        Next
    Next
    Return result
End Function
