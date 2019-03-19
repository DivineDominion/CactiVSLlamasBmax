SuperStrict

import "CTLogging.bmx"
import "CTWindow.bmx"

Function Draw:Int()
    For Local win:CTWindow = EachIn CTWindow.AllWindows()
        win.Draw()
    Next

    displayLog.Draw(0, 0, 15)
End Function
