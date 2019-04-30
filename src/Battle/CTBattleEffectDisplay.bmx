SuperStrict

Import "../Battlefield/CTBattlefield.bmx"
Import "../Battlefield/CTBattlefieldView.bmx"
Import "../Battlefield/CTTokenPosition.bmx"
Import "../Army/CTCharacter.bmx"
Import "../Util/CTInteger.bmx"
Import "CTDamageEffectView.bmx"
Import "CTDeathEffectView.bmx"

Type CTBattleEffectDisplay
    Private
    Field battlefield:CTBattlefield
    Field battlefieldView:CTBattlefieldView

    Method New(); End Method

    Public
    Method New(battlefield:CTBattlefield, battlefieldView:CTBattlefieldView)
        Self.battlefield = battlefield
        Self.battlefieldView = battlefieldView
    End Method


    '#Region Effects
    Public
    Method OnCharacterDidTakeDamage(character:CTCharacter, damagePayload:CTInteger)
        Local tokenBounds:CTRect = Self.TokenBoundsForCharacter(character)
        If Not tokenBounds Then Return
        Local damageLabel:CTDamageEffectView = New CTDamageEffectView("-" + damagePayload.ToString(), tokenBounds)
        battlefieldView.AddSubview(damageLabel)
    End Method

    Method OnCharacterDidDie(character:CTCharacter)
        Local tokenBounds:CTRect = Self.TokenBoundsForCharacter(character)
        If Not tokenBounds Then Return
        Local deathEffect:CTDeathEffectView = New CTDeathEffectView(tokenBounds)
        deathEffect.bounds = tokenBounds
        battlefieldView.AddSubview(deathEffect)
    End Method

    Private
    Method TokenBoundsForCharacter:CTRect(character:CTCharacter)
        Local tokenPosition:CTTokenPosition = Self.battlefield.PositionOfTokenForCharacter(character)
        If Not tokenPosition Then Return Null
        Return Self.battlefieldView.RectForTokenPosition(tokenPosition)
    End Method
    '#End Region
End Type
