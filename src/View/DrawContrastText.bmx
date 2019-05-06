SuperStrict

Import "CTColor.bmx"

Public

Rem
bbdoc: Draw text with a shadow. Defaults to white text with black shadow.
End Rem
Function DrawContrastText(line$, x%, y%, textColor:CTColor = Null, shadowColor:CTColor = Null)
    If Not shadowColor
        shadowColor = _defaultShadowColor
    End If
    shadowColor.Set()
    DrawText line, x + 1, y + 1

    If Not textColor
        textColor = _defaultTextColor
    End If
    textColor.Set()
    DrawText line, x, y
End Function

Private
' Store the default colors as private globals so we don't have to create
' new objects for every operation.
Global _defaultShadowColor:CTColor = CTColor.ShadowColor()
Global _defaultTextColor:CTColor = CTColor.DefaultTextColor()
