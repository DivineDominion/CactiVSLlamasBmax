SuperStrict

import "CTColor.bmx"
import "CTRect.bmx"

Type CTWindow
    Private
    Field rect:CTRect
    Field color:CTColor
    Global defaultColor:CTColor
    Global windows:CTWindow[]

    Public
    Field drawContentBlock:Int()

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
        rect.Translate(1, 1).Draw()

        ' Frame
        SetColor 255, 255, 255
        rect.Draw()

        ' Content
        color.Set()
        rect.Inset(1, 1).Draw(drawContentBlock)
    End Method

    Function DrawAllWindows()
        For Local win:CTWindow = EachIn windows
            win.Draw()
        Next
    End Function

    Method GetMaxY:Int()
        Return rect.GetMaxY()
    End Method
End Type
