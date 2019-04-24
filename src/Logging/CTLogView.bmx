SuperStrict

Import "CTDisplayLog.bmx"
Import "../View/CTView.bmx"

Type CTLogView Extends CTView
    Const LINES:Int = 6

    Private
    Field displayLog:CTDisplayLog

    Public
    Method New()
        Self.backgroundColor = CTColor.DarkGray()
        Self.isOpaque = True
    End Method

    Function Create:CTLogView(displayLog:CTDisplayLog)
        Assert displayLog Else "CTLogView.Create required displayLog"
        Local view:CTLogView = New CTLogView()
        view.displayLog = displayLog
        Return view
    End Function

    Method Draw(dirtyRect:CTRect)
        Super.Draw(dirtyRect)
        displayLog.Draw(1, 0, LINES)
    End Method

    Method InstrinsicHeight:Int()
        Return TextHeight("x") * LINES
    End Method
End Type
