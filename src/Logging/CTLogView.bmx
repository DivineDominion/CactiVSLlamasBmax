SuperStrict

Import "CTDisplayLog.bmx"
Import "../View/CTView.bmx"

Type CTLogView Extends CTView
    Private
    Field displayLog:CTDisplayLog

    Public
    Method New()
        Self.bgColor = CTColor.DarkGray()
    End Method

    Function Create:CTLogView(displayLog:CTDisplayLog)
        Assert displayLog Else "CTLogView.Create required displayLog"
        Local view:CTLogView = New CTLogView()
        view.displayLog = displayLog
        Return view
    End Function

    Method Draw(dirtyRect:CTRect)
        Super.Draw(dirtyRect)
        displayLog.Draw(1, 0, 3)
    End Method
End Type
