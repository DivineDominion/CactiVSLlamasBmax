SuperStrict

Import "../Battlefield/CTBattlefield.bmx"
Import "../Battlefield/CTBattlefieldView.bmx"
Import "../Battlefield/CTTokenPosition.bmx"
Import "../Army/CTCharacter.bmx"
Import "../Util/CTInteger.bmx"
Import "CTDamageEffectView.bmx"

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
        Local tokenPosition:CTTokenPosition = Self.battlefield.PositionOfTokenForCharacter(character)
        If Not tokenPosition Then Return
        Local tokenBounds:CTRect = Self.battlefieldView.RectForTokenPosition(tokenPosition)
        Local damageLabel:CTDamageEffectView = New CTDamageEffectView("-" + damagePayload.ToString(), tokenBounds)
        battlefieldView.AddSubview(damageLabel)
    End Method
    '#End Region
End Type
