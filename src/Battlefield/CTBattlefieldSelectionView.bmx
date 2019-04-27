SuperStrict

Import "../View/CTControl.bmx"
Import "../View/CTColor.bmx"

Type CTBattlefieldSelectionView Extends CTControl
    '#Region CTAnimatable
    Public
    Method ResetAnimation()
        Self.timeSinceLastUpdate = 0
        Self.currentFrame = 0
    End Method

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
    Field interval:Float = 0.1 * MSEC_PER_SEC
    Field timeSinceLastUpdate:Float = 0
    Field currentFrame:Int = 0
    Field colors:CTColor[] = [CTColor.White(), ..
                              CTColor.LightGray(), ..
                              CTColor.Gray(), ..
                              CTColor.DarkGray(), ..
                              CTColor.DarkGray(), ..
                              CTColor.Gray(), ..
                              CTColor.LightGray(), ..
                              CTColor.White()]

    Method GetCurrentStrokeColor:CTColor()
        Return Self.colors[Self.currentFrame]
    End Method
    '#End Region


    '#Region CTDrawable
    Private
    Field strokeWidth:Int = 2

    Public
    Method Draw(dirtyRect:CTRect)
        Local x%, y%, w%, h%
        dirtyRect.GetSize(w, h)
        Local cornerWidth% = dirtyRect.GetWidth() / 4
        Local cornerHeight% = dirtyRect.GetHeight() / 4

        Self.GetCurrentStrokeColor.Set()

        ' Top left
        DrawRect x, y, cornerWidth, strokeWidth
        DrawRect x, y, strokeWidth, cornerHeight

        ' Top right
        DrawRect x+w, y, -cornerWidth, strokeWidth
        DrawRect x+w, y, -strokeWidth, cornerHeight

        ' Bottom left
        DrawRect x, y+h, cornerWidth, -strokeWidth
        DrawRect x, y+h, strokeWidth, -cornerHeight

        ' Bottom right
        DrawRect x+w, y+h, -cornerWidth, -strokeWidth
        DrawRect x+w, y+h, -strokeWidth, -cornerHeight
    End Method
    '#End Region
End Type
