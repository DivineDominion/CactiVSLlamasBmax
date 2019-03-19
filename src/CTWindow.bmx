SuperStrict

Type CTWindow
    Private
    Field rect:CTRect
    Field color:CTColor
    Global defaultColor:CTColor
    Global windows:CTWindow[]

    Public
    Function SetDefaultColor(newColor:CTColor)
        defaultColor = newColor
    End Function

    Function AllWindows:CTWindow[]()
        Return windows
    End Function

    Method New()
        ' Resize array
        Local oldWins:CTWindow[] = CTWindow.windows
        Local newWins:CTWindow[] = New CTWindow[oldWins.length + 1]
        For Local i:Int = 0 Until oldWins.length
            newWins[i] = oldWins[i]
        Next
        ' Append new element
        newWins[newWins.length - 1] = Self
        CTWindow.windows = newWins
    End Method

    Function Create:CTWindow(x%, y%, w%, h%, color:CTColor = Null)
        Local win:CTWindow = New CTWindow
        win.rect = CTRect.Create(x, y, w, h)

        If color = Null Then
            If defaultColor = Null Then
                win.color = CTColor.Create(0, 0, 0)
            Else
                win.color = CTWindow.defaultColor
            EndIf
        Else
            win.color = color
        EndIf

        Return win
    End Function

    Method Draw()
        ' Shadow
        SetColor 0, 0, 0
        rect.Translate(2, 2).Draw()

        ' Frame
        SetColor 255, 255, 255
        rect.Draw()

        ' Content
        color.Set()
        rect.Inset(2, 2).Draw()
    End Method
End Type

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

Type CTRect
    Private
    Field x%, y%, w%, h%

    Public
    Function Create:CTRect(x%, y%, w%, h%)
        Local rect:CTRect = New CTRect
        rect.x = x
        rect.y = y
        rect.w = w
        rect.h = h
        Return rect
    End Function

    Method Inset:CTRect(dx%, dy%)
        Local w% = max(Self.w - (dx * 2), 0)
        Local h% = max(Self.h - (dy * 2), 0)
        Return CTRect.Create(Self.x + dx, Self.y + dy, w, h)
    End Method

    Method Translate:CTRect(dx%, dy%)
        Return CTRect.Create(Self.x + dx, Self.y + dy, Self.w, Self.h)
    End Method

    Method Draw()
        DrawRect x, y, w, h
    End Method
End Type