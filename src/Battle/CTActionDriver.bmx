SuperStrict

Import "CTDrivesActions.bmx"
Import "CTTargetedEffect.bmx"

Type CTActionDriver Implements CTDrivesActions
    Method Drive(action:CTActionable)
        action.ExecuteInDriver(Self)
    End Method

    Method SelectEffectTarget:CTEffectTarget()
        Return Null
    End Method

    Method ApplyEffectToTarget(effect:CTTargetedEffect, target:CTEffectTarget)
        effect.ApplyToTarget(target:CTEffectTarget)
    End Method
End Type
