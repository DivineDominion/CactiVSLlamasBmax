SuperStrict

Import "../View/CTColor.bmx"
Import "../View/CTView.bmx"
Import "../View/DrawContrastText.bmx"

Type CTDamageEffectView Extends CTView
    Private
    Field damageLabel:String

    Public
    Method New(damageLabel:String, bounds:CTRect)
        Self.damageLabel = damageLabel
        Self.bounds = bounds
    End Method


    '#Region CTAnimatable
    Private
    Field duration# = 1 * MSEC_PER_SEC
    Field elapsedTime# = 0

    Public
    Method UpdateAnimation(delta:Float)
        Self.elapsedTime :+ delta

        If Self.elapsedTime >= Self.duration
            Self.RemoveFromSuperview()
        End If
    End Method
    '#End Region


    '#Region CTDrawable
    Private
    Field maxDistance# = TextHeight("x") * 1.5
    Field labelColor:CTColor = CTColor.DamageColor()

    Public
    Method Draw(dirtyRect:CTRect)
        If Self.elapsedTime >= Self.duration Then Return

        ' Animate alpha value and offset
        Local progressPercentage# = Self.elapsedTime / Self.duration
        Local offset# = Self.maxDistance * progressPercentage
        Local oldAlpha# = GetAlpha()
        Local alpha# = 1.0 - progressPercentage

        Local lineHeight:Int = TextHeight("x")
        Local y% = dirtyRect.GetMaxY() - lineHeight - offset
        Local x% = (dirtyRect.GetWidth() - TextWidth(Self.damageLabel)) / 2

        Local oldBlend% = GetBlend()
        SetBlend(ALPHABLEND)
        SetAlpha(alpha)
        DrawContrastText(Self.damageLabel, x, y, Self.labelColor)
        SetAlpha(oldAlpha)
        SetBlend(oldBlend)
    End Method
    '#End Region
End Type