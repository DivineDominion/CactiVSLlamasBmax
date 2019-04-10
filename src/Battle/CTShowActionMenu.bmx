SuperStrict

Import "../View/CTMenu.bmx"
Import "../View/CTRect.bmx"
Import "../View/CTWindow.bmx"
Import "../View/CTWindowManager.bmx"

Interface CTShowActionMenuDelegate
    Method showActionMenuDidSelectMenuItem(showActionMenu:CTShowActionMenu, menuItem:CTMenuItem)
End Interface

Type CTShowActionMenu Implements CTMenuDelegate
    Private
    Field frameRect:CTRect
    Field menu:CTMenu
    Field currentWindow:CTWindow = Null

    Method New(); End Method


    Public
    Field delegate:CTShowActionMenuDelegate = Null

    Function Create:CTShowActionMenu(frameRect:CTRect, lines:String[])
        Local service:CTShowActionMenu = New CTShowActionMenu
        service.frameRect = frameRect
        service.menu = CTMenu.Create(lines)
        Return service
    End Function

    Method ShowMenu()
        Assert Not Self.currentWindow Else "#ShowMenu called before closing the window"

        Self.currentWindow = CTWindow.Create(Self.frameRect, Self.menu)
        CTWindowManager.GetInstance().AddWindow(currentWindow)
        menu.delegate = Self ' Creates a retain cycle
        menu.MakeFirstResponder()
    End Method

    '#Region CTMenuDelegate
    Method MenuDidSelectMenuItem(menu:CTMenu, menuItem:CTMenuItem)
        If Self.menu <> menu Then Return

        menu.RemoveDelegate() ' Breaks the retain cycle
        menu.ResignFirstResponder()
        menu.ResetSelection()
        CTWindowManager.GetInstance().RemoveWindow(currentWindow)
        Self.currentWindow = Null

        ' FIXME: Cannot call delegate with `Self.` prefix, see: <https://github.com/bmx-ng/bcc/issues/428>
        If Self.delegate Then delegate.showActionMenuDidSelectMenuItem(Self, menuItem)
    End Method
    '#End Redion
End Type
