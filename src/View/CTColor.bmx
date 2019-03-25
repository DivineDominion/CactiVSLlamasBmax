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
End Type
