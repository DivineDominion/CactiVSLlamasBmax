SuperStrict

Import "../View/CTMenu.bmx"
Import "../View/CTRect.bmx"
Import "../View/CTWindow.bmx"
Import "../View/CTWindowManager.bmx"

Interface CTShowActionMenuDelegate
    Method ShowActionMenuDidSelectAction(showActionMenu:CTShowActionMenu, action:String)
End Interface

Type CTShowActionMenu Implements CTMenuDelegate
    Private
    Field frameRect:CTRect
    Field characterName:String
    Field menu:CTMenu
    Field currentWindow:CTWindow = Null

    Method New(); End Method


    Public
    Field delegate:CTShowActionMenuDelegate = Null

    Method New(frameRect:CTRect, actions:String[], characterName:String)
        Self.frameRect = frameRect
        Self.menu = New CTMenu(actions)
        Self.characterName = characterName
    End Method

    Method ShowMenu()
        Assert Not Self.currentWindow Else "#ShowMenu called before closing the window"

        Self.currentWindow = CTWindow.Create(Self.frameRect, Self.menu, Self.characterName)
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
        If Self.delegate Then delegate.ShowActionMenuDidSelectAction(Self, menuItem.label)
    End Method

    Method MenuShouldWrapAround:Int(menu:CTMenu, forwardDirection:Int)
        Return True
    End Method
    '#End Redion
End Type
