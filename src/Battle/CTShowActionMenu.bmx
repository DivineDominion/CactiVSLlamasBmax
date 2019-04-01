SuperStrict

Import "../View/CTMenu.bmx"
Import "../View/CTRect.bmx"
Import "../View/CTWindow.bmx"
Import "../View/CTWindowManager.bmx"
Import "../Logging.bmx"

Type CTShowActionMenu Implements CTMenuDelegate
    Private
    Field frameRect:CTRect
    Field menu:CTMenu
    Field currentWindow:CTWindow = Null


    Public
    Function Create:CTShowActionMenu(frameRect:CTRect)
        Local service:CTShowActionMenu = New CTShowActionMenu
        service.frameRect = frameRect
        service.menu = CTMenu.Create(["Fight", "Move", "Run"])
        Return service
    End Function

    Method ShowMenu()
        Assert Not Self.currentWindow Else "#ShowMenu called before closing the window"

        Self.currentWindow = CTWindow.Create(Self.frameRect, Self.menu)
        windowManager.AddWindow(currentWindow)
        menu.delegate = Self ' Creates a retain cycle
        menu.MakeFirstResponder()
    End Method

    '#Region CTMenuDelegate
    Method MenuDidSelectMenuItem(menu:CTMenu, menuItem:CTMenuItem)
        If Self.menu <> menu
            Return
        End If

        mainLog.Append("PICK: " + menuItem.label)

        menu.RemoveDelegate() ' Breaks the retain cycle
        windowManager.RemoveWindow(currentWindow)
        Self.currentWindow = Null
    End Method
    '#End Redion
End Type
