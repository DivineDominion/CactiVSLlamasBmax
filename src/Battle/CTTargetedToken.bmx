SuperStrict

Import "../Battlefield/CTToken.bmx"
Import "../Army/CTCharacter.bmx"
Import "CTTargetedEffect.bmx"

Type CTTargetedToken Implements CTEffectTarget
    Private
    Field token:CTToken

    Public
    Method New(token:CTToken)
        Self.token = token
    End Method

    '#Region CTEffectTarget
    Method OnInflictDamage(damage:Int)
        ' TODO inflict damage
    End Method
End Type
