SuperStrict

Import "CTDrawable.bmx"
Import "CTColor.bmx"

Rem
Treat `CTView` drawing as if it's the only thing on screen. The `dirtyRect`
is supposed to start at (0,0) in a viewport, so you don't need to worry about offsets.

Fills its interior with its `defaultBgColor` in `Draw(dirtyRect)` by default.
EndRem
Type CTView Implements CTDrawable
    Private

    Public
    Field isOpaque:Int = True
    Global defaultBgColor:CTColor = CTColor.Blue()
    Field bgColor:CTColor

    Method New()
        Self.bgColor = defaultBgColor
    End Method

    '#Region CTDrawable
    Method Draw(dirtyRect:CTRect)
        If Not Self.isOpaque Then Return
        If Not Self.bgColor Then Return

        bgColor.Set()
        dirtyRect.Fill()
    End Method
    '#End Region
End Type

Function fallback:CTColor(lhs:CTColor, rhs:CTColor)
    If rhs = Null RuntimeError "default()'s rhs may not be Null"
    If lhs = Null Then
        Return rhs
    EndIf
    Return lhs
End Function
