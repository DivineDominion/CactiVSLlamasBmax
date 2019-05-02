SuperStrict

Import "CTActionable.bmx"
Import "CTDamageEffect.bmx"
Import "../Army/CTCharacter.bmx"

Type CTTackleAction Implements CTActionable, CTTargetableActionable
    Private
    Field damage:Int

    Public
    Method New(character:CTCharacter)
        Self.damage = character.GetDamage()
    End Method

    '#Region CTActionable
    Public
    Method GetLabel:String()
        Return "Tackle"
    End Method

    Method ExecuteInDriver(driver:CTDrivesActions)
        driver.SelectEffectTargetForAction(Self)
    End Method

    Method ExecuteInDriverWithTarget(driver:CTDrivesActions, target:CTEffectTarget)
        Assert driver Else "#ExecuteInDriverWithTarget expects driver"

        If Not target Then Return

        Local effect:CTTargetedEffect = New CTDamageEffect(Self.damage)
        driver.ApplyEffectToTarget(effect, target)
    End Method
    '#End Region
End Type

