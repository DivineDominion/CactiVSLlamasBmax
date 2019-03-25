SuperStrict

import "CTDisplayLog.bmx"
import "../View/CTView.bmx"

Type CTLogView Extends CTView
    Private
    Field displayLog:CTDisplayLog

    Public
    Function Create:CTLogView(displayLog:CTDisplayLog)
        Assert(displayLog)
        Local view:CTLogView = New CTLogView()
        view.displayLog = displayLog
        Return view
    End Function

    Method Draw(dirtyRect:CTRect)
        Super.Draw(dirtyRect)
        displayLog.Draw(1, 0, 3)
    End Method
End Type
