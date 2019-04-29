SuperStrict

Import "CTTargetedEffect.bmx"

Type CTDamageEffect Implements CTTargetedEffect
    Private
    Method New(); End Method

    Public
    Field ReadOnly damage:Int

    Method New(damage:Int)
        Self.damage = damage
    End Method

    '#Region CTTargetedEffect
    Method ApplyToTarget(target: CTEffectTarget)
        target.OnInflictDamage(damage)
    End Method
    '#End Region
End Type
