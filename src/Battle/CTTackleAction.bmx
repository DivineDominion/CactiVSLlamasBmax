SuperStrict

Import "CTActionable.bmx"
Import "CTDamageEffect.bmx"

Type CTTackleAction Implements CTActionable
    '#Region CTActionable
    Public
    Method GetLabel:String()
        Return "Tackle"
    End Method

    Method ExecuteInDriver:Int(driver:CTDrivesActions)
        Local target:CTEffectTarget = driver.SelectEffectTarget()
        If Not target Then Return False

        Local effect:CTTargetedEffect = New CTDamageEffect(123)
        driver.ApplyEffectToTarget(effect, target)

        Return True
    End Method
    '#End Region
End Type

