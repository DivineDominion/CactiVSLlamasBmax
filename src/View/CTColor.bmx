SuperStrict

Type CTColor
    Private
    Field r%, g%, b%


    Public
    Function Create:CTColor(r%, g%, b%)
        Local color:CTColor = New CTColor
        color.r = r
        color.g = g
        color.b = b
        Return color
    End Function

    Method Set()
        SetColor r, g, b
    End Method

    Method SetCls()
        SetClsColor r, g, b
    End Method

    '#Region Names Colors
    Function White:CTColor()
        Return CTColor.Create(255, 255, 255)
    End Function

    Function LightGray:CTColor()
        Return CTColor.Create(191, 191, 191)
    End Function

    Function Gray:CTColor()
        Return CTColor.Create(127, 127, 127)
    End Function

    Function DarkGray:CTColor()
        Return CTColor.Create(63, 63, 63)
    End Function

    Function Black:CTColor()
        Return CTColor.Create(0, 0, 0)
    End Function
    '#End Region
End Type
