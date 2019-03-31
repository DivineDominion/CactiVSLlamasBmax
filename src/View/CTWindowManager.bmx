SuperStrict

Import "../Util/CTMutableArray.bmx"
Import "CTWindow.bmx"

Global windowManager:CTWindowManager = New CTWindowManager

Rem
Yeah, I know, a "Manager" class ... I tried to keep the `windows` collection
a private global/static class variable in `CTWindow`, but that didn't work
at all. The compiler fails to build, that's it.
EndRem
Type CTWindowManager
    Private
    Field windows:CTMutableArray = New CTMutableArray

    Public
    Method AllWindows:CTWindow[]()
        Return Self.windows.ToArray()
    End Method

    Method AddWindow(win:CTWindow)
        Self.windows.Append(win)
    End Method

    Method DrawAllWindows()
        For Local win:CTWindow = EachIn Self.windows
            win.Draw()
        Next
    End Method
End Type
