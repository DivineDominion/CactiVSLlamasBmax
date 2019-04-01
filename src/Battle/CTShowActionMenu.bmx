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


    '#Region Singleton
    Public
    Function Instance:CTShowActionMenu(initialFrameRect:CTRect = Null)
        If Not _instance
            Assert initialFrameRect Else "CTShowActionMenu singleton needs initialFrameRect once"
            _instance = Create(initialFrameRect)
        End If
        Return _instance
    End Function

    Private
    Global _instance:CTShowActionMenu = Null

    Method New(); End Method

    Function Create:CTShowActionMenu(frameRect:CTRect)
        Local service:CTShowActionMenu = New CTShowActionMenu
        service.frameRect = frameRect
        service.menu = CTMenu.Create(["Fight", "Move", "Run"])
        Return service
    End Function
    '#End Region


    Public
    Method ShowMenu()
        Assert Not Self.currentWindow Else "#ShowMenu called before closing the window"

        Self.currentWindow = CTWindow.Create(Self.frameRect, Self.menu)
        windowManager.AddWindow(currentWindow)
        menu.delegate = Self ' Creates a retain cycle
        menu.MakeFirstResponder()
    End Method

    '#Region CTMenuDelegate
    Method MenuDidSelectMenuItem(menu:CTMenu, menuItem:CTMenuItem)
        If Self.menu <> menu Then Return

        mainLog.Append("PICK: " + menuItem.label)

        menu.RemoveDelegate() ' Breaks the retain cycle
        menu.ResignFirstResponder()
        windowManager.RemoveWindow(currentWindow)
        Self.currentWindow = Null
    End Method
    '#End Redion
End Type
