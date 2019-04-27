SuperStrict

Import "CTTargetedEffect.bmx"

Rem
The driver is oblivious to how an action works. It just carries out the
commands issued by the currently active action.
End Rem
Interface CTDrivesActions
    Rem
    returns: Null to abort, or a target for the action's effect.
    End Rem
    Method SelectEffectTarget:CTEffectTarget()

    Method ApplyEffectToTarget(effect:CTTargetedEffect, target:CTEffectTarget)
End Interface
