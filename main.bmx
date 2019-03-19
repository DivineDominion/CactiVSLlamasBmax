SuperStrict

import "src/CTScreen.bmx"
import "src/CTLogging.bmx"
import "src/CTDraw.bmx"

Global mainScreen:CTScreen = CTScreen.Create(800, 800)
displayLog.Append("ESC to Quit")

SetClsColor 128, 128, 128

Repeat
    mainScreen.Update(Draw)
Until KeyDown(Key_Escape) Or AppTerminate()
