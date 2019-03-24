SuperStrict

import "src/CTScreen.bmx"
import "src/CTLogging.bmx"
import "src/CTDraw.bmx"
import "src/CTWindow.bmx"
import "src/CTView.bmx"

Global mainScreen:CTScreen = CTScreen.Create(400, 400)
displayLog.Append("ESC to Quit")

Local bgColor:CTColor = CTColor.Create(128, 128, 128)
bgColor.SetCls()
CTView.defaultBgColor = bgColor

Type CTLogView Extends CTView
    Method Draw(dirtyRect:CTRect)
        Super.Draw(dirtyRect)
        displayLog.Draw(1, 0, 3)
    End Method
End Type

Local logWin:CTWindow = CTWindow.Create(0, 0, 400, TextHeight("x") * 3, New CTLogView())

Type CTTestView Extends CTView
    Method Draw(dirtyRect:CTRect)
        Super.Draw(dirtyRect)
        SetColor 255,255,0
        SetLineWidth 1
        DrawLine 0,0,100,100
    End Method
End Type

Local characterWindow:CTWindow = CTWindow.Create(10, logWin.GetMaxY() + 2, 380, 100, New CTTestView())

Repeat
    mainScreen.Update(Draw)
Until KeyDown(Key_Escape) Or AppTerminate()
