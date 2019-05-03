SuperStrict

Import "../Event.bmx"
Import "../View/CTColor.bmx"
Import "../View/CTView.bmx"
Import "../View/DrawContrastText.bmx"

Type CTDeathEffectView Extends CTView
    Public
    Method New(bounds:CTRect)
        Self.bounds = bounds
    End Method


    '#Region CTAnimatable
    Private
    ' Hard-coded random numbers for coordinate offsets and time deltas.
    ' Keep uneven for less repetition in 2-component offsets
    Field OFFSET_RNG:Int[] = [1,-1,2,1, 0,-1,0,-1, 1,0,1,2, 1,-1,0]
    Field offsetRNGIndex:Int = 0
    Field TIME_RNG:Int[] = [1,2,3,3, 4,3,2,1, 3,4,5,2, 2,3,1]
    Field timeRNGIndex:Int = 0

    Field duration# = 1 * MSEC_PER_SEC
    Field elapsedTime# = 0
    Field timeUntilNextStep# = 0
    Field xOff%, yOff%
    Field backgroundAlpha# = 0

    Public
    Method AutostartsAnimation:Int()
        Return False
    End Method

    Method UpdateAnimation(delta:Float)
        Super.UpdateAnimation(delta)

        If Not IsAnimating() Then Return

        Self.elapsedTime :+ delta

        ' Update animation steps periodically
        If Self.elapsedTime >= Self.timeUntilNextStep
            Self.xOff = NextOffset()
            Self.yOff = NextOffset()
            Self.timeUntilNextStep :+ NextTimeDelta()
        End If

        Local progressPercentage# = Self.elapsedTime / Self.duration
        Self.backgroundAlpha = progressPercentage

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

    Private
    Method NextTimeDelta:Float()
        Local result:Float = (1.0 / TIME_RNG[Self.timeRNGIndex])

        Self.timeRNGIndex :+ 1
        If Self.timeRNGIndex >= TIME_RNG.length Then Self.timeRNGIndex = 0

        Return result
    End Method

    Method NextOffset:Int()
        Local result:Int = OFFSET_RNG[Self.offsetRNGIndex]

        Self.offsetRNGIndex :+ 1
        If Self.offsetRNGIndex >= OFFSET_RNG.length Then Self.offsetRNGIndex = 0

        Return result
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
    Const TEXT:String = "DEATH!"
    Field maxDistance# = TextHeight("x") * 1.5
    Field labelColor:CTColor = CTColor.White()
    Field backgroundColor:CTColor = CTColor.Black()

    Public
        If Not Self.IsAnimating() Then Return
    Method DrawInterior(dirtyRect:CTRect)
        DrawBackground(dirtyRect)
        DrawText(dirtyRect)
    End Method

    Private
    Method DrawBackground(dirtyRect:CTRect)
        Local oldBlend% = GetBlend()
        Local oldAlpha# = GetAlpha()
        SetBlend(ALPHABLEND)
        SetAlpha(Self.backgroundAlpha)

        backgroundColor.Set()
        dirtyRect.Fill()

        SetAlpha(oldAlpha)
        SetBlend(oldBlend)
    End Method

    Method DrawText(dirtyRect:CTRect)
        Local x% = (dirtyRect.GetWidth() - TextWidth(TEXT)) / 2 + Self.xOff
        Local y% = (dirtyRect.GetHeight() - TextHeight(TEXT)) / 2 + Self.yOff
        DrawContrastText(TEXT, x, y, Self.labelColor)
    End Method
    '#End Region
End Type