SuperStrict

import "src/CTScreen.bmx"
import "src/CTLogging.bmx"
import "src/CTDraw.bmx"
import "src/CTWindow.bmx"

Global mainScreen:CTScreen = CTScreen.Create(400, 400)
displayLog.Append("ESC to Quit")

Local bgColor:CTColor = CTColor.Create(128, 128, 128)
bgColor.SetCls()
CTWindow.SetDefaultColor(bgColor)

Local logWin:CTWindow = CTWindow.Create(0, 0, 400, TextHeight("x") * 3)
logWin.drawContentBlock = DrawLogContent

Function DrawLogContent:Int()
    displayLog.Draw(1, 0, 3)
End Function

Local win:CTWindow = CTWindow.Create(10, logWin.GetMaxY() + 2, 380, 100)
win.drawContentBlock = DrawContent

Function DrawContent:Int()
    SetColor 255,255,0
    SetLineWidth 1
    DrawLine 0,0,100,100
End Function

Repeat
    mainScreen.Update(Draw)
Until KeyDown(Key_Escape) Or AppTerminate()
