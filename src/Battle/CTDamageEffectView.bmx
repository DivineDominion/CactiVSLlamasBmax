SuperStrict

Import "../Event.bmx"
Import "../View/CTColor.bmx"
Import "../View/CTView.bmx"
Import "../View/DrawContrastText.bmx"

Type CTDamageEffectView Extends CTView
    Private
    Field damageLabel:String

    Public
    Method New(damageLabel:String)
        Self.damageLabel = damageLabel
    End Method


    '#Region CTAnimatable
    Private
    Field duration# = 1 * MSEC_PER_SEC
    Field elapsedTime# = 0

    Public
    Method AutostartsAnimation:Int()
        Return False
    End Method

    Method UpdateAnimation(delta:Float)
        Super.UpdateAnimation(delta)

        If Not IsAnimating() Then Return

        Self.elapsedTime :+ delta

        ' Auto-stop animation
        If Self.elapsedTime >= Self.duration
            Self.StopAnimation()
            Fire("AnimationDidComplete", Self)
        End If
    End Method

    ' FIXME: expect :CTAnimatable when <https://github.com/bmx-ng/bcc/issues/437> is implemented
    Method OnAnimationDidComplete(animatable:Object)
        If animatable <> Self Then Return
        Self.RemoveFromSuperview()
    End Method
    '#End Region


    '#Region View hierarchy callbacks
    Public
    Method ViewWillMoveToSuperview(superview:CTView)
        If superview
            AddListener(Self)
        Else
            RemoveListener(Self)
        End If
    End Method
    '#End Region


    '#Region CTDrawable
    Private
    Field maxDistance# = TextHeight("x") * 1.5
    Field labelColor:CTColor = CTColor.DamageColor()

    Public
    Method DrawInterior(dirtyRect:CTRect)
        If Not Self.IsAnimating() Then Return

        ' Animate alpha value and offset
        Local progressPercentage# = Self.elapsedTime / Self.duration
        Local offset# = Self.maxDistance * progressPercentage
        Local oldAlpha# = GetAlpha()
        Local alpha# = 1.0 - progressPercentage

        Local lineHeight:Int = TextHeight("x")
        Local y% = dirtyRect.GetHeight() - lineHeight - offset
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