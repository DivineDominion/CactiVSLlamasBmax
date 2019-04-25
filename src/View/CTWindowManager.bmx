SuperStrict

Import "../Util/CTMutableArray.bmx"
Import "CTWindow.bmx"

Rem
Yeah, I know, a "Manager" class ... I tried to keep the `windows` collection
a private global/static class variable in `CTWindow`, but that didn't work
at all. The compiler fails to build, that's it.
EndRem
Type CTWindowManager
    Private
    Field windows:CTMutableArray = New CTMutableArray

    Public
    Function GetInstance:CTWindowManager()
        Return windowManager
    End Function

    Method AllWindows:CTWindow[]()
        Return Self.windows.ToArray()
    End Method

    Rem
    returns: Window from the window list where #contentView is the same object, or Null.
    EndRem
    Method WindowWithContentView:CTWindow(contentView:Object)
        For Local win:CTWindow = EachIn self.windows
            If win.GetContentView() = contentView Then Return win
        Next
        Return Null
    End Method

    Method AddWindow(win:CTWindow)
        Self.windows.Append(win)
    End Method

    Method AddWindowAndMakeKey(win:CTWindow)
        Self.AddWindow(win)
        win.MakeKey()
    End Method

    Method RemoveWindow(win:CTWindow)
        win.TearDown()
        Self.windows.RemoveFirst(win)
    End Method

    Method DrawAllWindows()
        For Local win:CTWindow = EachIn Self.windows
            win.Draw()
        Next
    End Method

    Method UpdateAllAnimations(delta:Float)
        For Local win:CTWindow = EachIn Self.windows
            win.UpdateAnimation(delta)
        Next
    End Method
End Type

Private
Global windowManager:CTWindowManager = New CTWindowManager
