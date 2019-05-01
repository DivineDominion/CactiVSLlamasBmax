SuperStrict

Import "../Operation.bmx"
Import "../Battlefield/CTBattlefield.bmx"
Import "../Battlefield/CTBattlefieldView.bmx"
Import "../Battlefield/CTTokenPosition.bmx"
Import "../Army/CTCharacter.bmx"
Import "CTDamageEffectView.bmx"
Import "CTDeathEffectView.bmx"

Type CTBattleEffectDisplay Implements CTCharacterAnimator
    Private
    Field battlefield:CTBattlefield
    Field battlefieldView:CTBattlefieldView

    Method New(); End Method

    Public
    Method New(battlefield:CTBattlefield, battlefieldView:CTBattlefieldView)
        Self.battlefield = battlefield
        Self.battlefieldView = battlefieldView
    End Method


    '#Region CTCharacterAnimator
    Public
    Method CharacterTakingDamageAnimationOperation:CTOperation(character:CTCharacter, damage:Int)
        Local tokenBounds:CTRect = Self.TokenBoundsForCharacter(character)
        If Not tokenBounds Then Return New CTNullOperation()

        Local damageEffectView:CTDamageEffectView = New CTDamageEffectView("-" + String(damage), tokenBounds)
        battlefieldView.AddSubview(damageEffectView)

        Return New CTAnimationOperation(damageEffectView)
    End Method

    Method CharacterDyingAnimationOperation:CTOperation(character:CTCharacter)
        Local tokenBounds:CTRect = Self.TokenBoundsForCharacter(character)
        If Not tokenBounds Then Return New CTNullOperation()

        Local deathEffectView:CTDeathEffectView = New CTDeathEffectView(tokenBounds)
        deathEffectView.bounds = tokenBounds
        battlefieldView.AddSubview(deathEffectView)

        Return New CTAnimationOperation(deathEffectView)
    End Method

    Private
    Method TokenBoundsForCharacter:CTRect(character:CTCharacter)
        Local tokenPosition:CTTokenPosition = Self.battlefield.PositionOfTokenForCharacter(character)
        If Not tokenPosition Then Return Null
        Return Self.battlefieldView.RectForTokenPosition(tokenPosition)
    End Method
    '#End Region
End Type
