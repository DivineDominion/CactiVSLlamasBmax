SuperStrict

import "src/CTScreen.bmx"
import "src/CTDisplayLog.bmx"

Local mainScreen:CTScreen = CTScreen.Create(800, 800)
Local log:CTDisplayLog = CTDisplayLog.Create()

Repeat
    Cls

    log.Draw(0, 0, 20)
    log.Append("Hello,")
    log.Append("World!")

    Flip
Until KeyDown(Key_Escape)
