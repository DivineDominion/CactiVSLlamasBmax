SuperStrict

import "src/CTScreen.bmx"
import "src/CTLogging.bmx"
import "src/CTDraw.bmx"
import "src/CTWindow.bmx"

Global mainScreen:CTScreen = CTScreen.Create(800, 800)
displayLog.Append("ESC to Quit")

Local bgColor:CTColor = CTColor.Create(128, 128, 128)
bgColor.SetCls()
CTWindow.SetDefaultColor(bgColor)

CTWindow.Create(10, 10, 100, 100)

Repeat
    mainScreen.Update(Draw)
Until KeyDown(Key_Escape) Or AppTerminate()
