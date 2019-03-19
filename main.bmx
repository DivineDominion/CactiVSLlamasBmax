SuperStrict

import "src/CTScreen.bmx"
import "src/CTLogging.bmx"

Global mainScreen:CTScreen = CTScreen.Create(800, 800)

Repeat
    Cls
    displayLog.Draw(0, 0, 20)
    Flip
Until KeyDown(Key_Escape) Or AppTerminate()
