SuperStrict

Type CTColor
    Private
    Field r%, g%, b%

    Method New(); End Method

    Public
    Method New(r%, g%, b%)
        New()
        Self.r = r
        Self.g = g
        Self.b = b
    End Method

    Function Create:CTColor(r%, g%, b%)
        Return New CTColor(r, g, b)
    End Function

    Method Set()
        SetColor r, g, b
    End Method

    Method SetBackground()
        SetClsColor r, g, b
    End Method


    '#Region Semantic Colors - UI
    Function WindowFrameColor:CTColor()
        Return OffWhite()
    End Function

    Function DefaultMenuItemColor:CTColor()
        Return LightGray()
    End Function

    Function SelectedMenuItemColor:CTColor()
        Return White()
    End Function

    Function DisabledMenuItemColor:CTColor()
        Return DarkGray()
    End Function

    Function DefaultTextColor:CTColor()
        Return OffWhite()
    End Function

    Function ShadowColor:CTColor()
        Return Black()
    End Function
    '#End Region


    '#Region Semantic Colors - Game
    Function DamageColor:CTColor()
        Return Red()
    End Function
    '#End Region


    '#Region Names Colors
    Function White:CTColor()
        Return CTColor.Create(255, 255, 255)
    End Function

    Function OffWhite:CTColor()
        Return CTColor.Create(250, 250, 230)
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

    Function Red:CTColor()
        Return CTColor.Create(255, 0, 0)
    End Function

    Function Green:CTColor()
        Return CTColor.Create(0, 255, 0)
    End Function

    Function Blue:CTColor()
        Return CTColor.Create(0, 0, 255)
    End Function

    Function Yellow:CTColor()
        Return CTColor.Create(255, 255, 0)
    End Function
    '#End Region
End Type
