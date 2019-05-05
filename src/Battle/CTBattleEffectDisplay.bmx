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
        Local characterTokenView:CTTokenView = Self.battlefieldView.TokenViewForTokenWithCharacter(character)
        Assert characterTokenView
        If Not characterTokenView Then Return New CTNullOperation()

        Local damageEffectView:CTDamageEffectView = New CTDamageEffectView("-" + String(damage))
        characterTokenView.AddSubview(damageEffectView)

        Return New CTAnimationOperation(damageEffectView)
    End Method

    Method CharacterDyingAnimationOperation:CTOperation(character:CTCharacter)
        Local characterTokenView:CTTokenView = Self.battlefieldView.TokenViewForTokenWithCharacter(character)
        Assert characterTokenView
        If Not characterTokenView Then Return New CTNullOperation()

        Local deathEffectView:CTDeathEffectView = New CTDeathEffectView()
        characterTokenView.AddSubview(deathEffectView)

        Return New CTAnimationOperation(deathEffectView)
    End Method
    '#End Region
End Type
