SuperStrict

Import "../View/CTAnimatable.bmx"
Import "../View/CTColor.bmx"
Import "../View/CTRect.bmx"

Type CTTokenHighlighter Implements CTAnimatable
    Public
    Method DrawOnBattlefield(tokenRect:CTRect)
        Self.GetCurrentStrokeColor.Set()
        tokenRect.Stroke()
    End Method

    '#Region CTAnimatable
    Public
    Method UpdateAnimation(delta:Float)
        Self.timeSinceLastUpdate :+ delta

        If Self.timeSinceLastUpdate < interval Then Return
        Self.currentFrame :+ 1
        Self.timeSinceLastUpdate :- interval

        If Self.currentFrame >= colors.length
            Self.currentFrame = 0
        End If
    End Method

    Private
    Field interval:Float = 0.3 * MSEC_PER_SEC
    Field timeSinceLastUpdate:Float = 0
    Field currentFrame:Int = 0
    Field colors:CTColor[] = [CTColor.White(), ..
                              CTColor.LightGray(), ..
                              CTColor.Gray(), ..
                              CTColor.DarkGray()]

    Method GetCurrentStrokeColor:CTColor()
        Return Self.colors[Self.currentFrame]
    End Method
    '#End Region
End Type