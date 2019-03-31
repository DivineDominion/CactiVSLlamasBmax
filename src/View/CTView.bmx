SuperStrict

Import "IDrawable.bmx"
Import "CTColor.bmx"

Rem
Treat `CTView` drawing as if it's the only thing on screen. The `dirtyRect`
is supposed to start at (0,0) in a viewport, so you don't need to worry about offsets.

Fills its interior with its `defaultBgColor` in `Draw(dirtyRect)` by default.
EndRem
Type CTView Implements IDrawable
    Private

    Public
    Global defaultBgColor:CTColor = CTColor.Create(0,0,255)
    Field bgColor:CTColor

    Method New()
        Self.bgColor = defaultBgColor
    End Method

    Method Draw(dirtyRect:CTRect)
        If Self.bgColor = Null Then Return

        bgColor.Set()
        dirtyRect.Draw()
    End Method
End Type

Function fallback:CTColor(lhs:CTColor, rhs:CTColor)
    If rhs = Null RuntimeError "default()'s rhs may not be Null"
    If lhs = Null Then
        Return rhs
    EndIf
    Return lhs
End Function
