SuperStrict

Import "CTTargetedEffect.bmx"

Rem
Abstract action trait.
EndRem
Interface CTActionable
    Method GetLabel:String()
    Method ExecuteInDriver(driver:CTDrivesActions)
End Interface


Rem
Abstract action trait that requires a target.
End Rem
Interface CTTargetableActionable
    Method ExecuteInDriverWithTarget(driver:CTDrivesActions, target:CTEffectTarget)
End Interface


Rem
The driver is oblivious to how an action works. It just carries out the
commands issued by the currently active action.
End Rem
Interface CTDrivesActions
    Rem
    returns: Null to abort, or a target for the action's effect.
    End Rem
    Method SelectEffectTargetForAction(action:CTTargetableActionable)

    Method ApplyEffectToTarget(effect:CTTargetedEffect, target:CTEffectTarget)
End Interface

