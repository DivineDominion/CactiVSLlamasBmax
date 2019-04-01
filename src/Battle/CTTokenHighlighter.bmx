SuperStrict

Import "../View/CTColor.bmx"
Import "../View/CTRect.bmx"

Type CTTokenHighlighter
    Private
    Field strokeColor:CTColor = CTColor.White()

    Public
    Method DrawOnBattlefield(tokenRect:CTRect)
        strokeColor.Set()
        tokenRect.Stroke()
    End Method
End Type
