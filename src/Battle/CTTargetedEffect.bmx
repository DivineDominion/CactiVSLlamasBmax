SuperStrict

Rem
Abstraction of effect target is useful to e.g. avoid import cycle from CTCharacter and CTEffect. Use this interface instead as a 3rd thing.
End Rem
Interface CTEffectTarget
    Method OnInflictDamage(damage:Int)
End Interface

Interface CTTargetedEffect
    Method ApplyToTarget(target:CTEffectTarget)
End Interface
