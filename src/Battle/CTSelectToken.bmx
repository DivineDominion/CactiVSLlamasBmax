SuperStrict

Import "CTShowActionMenu.bmx"
Import "../View/CTWindow.bmx"
Import "../View/CTMenuItem.bmx"
Import "../Logging.bmx"

Interface CTSelectTokenDelegate
    Method SelectTokenDidSelectAction(selectToken:CTSelectToken, action:String)
End Interface

Type CTSelectToken Implements CTShowActionMenuDelegate
    Private
    Field currentMenuHandler:CTShowActionMenu = Null


    Public
    Field delegate:CTSelectTokenDelegate = Null

    Function CreateWithActionMenuRelativeToRect:CTSelectToken(rect:CTRect)
        Local service:CTSelectToken = New CTSelectToken
        Local lines:String[] = ["Fight", "Move", "", "Run"]
        Local menuFrameRect:CTRect = CTWindow.FrameRectFittingLines(..
            rect.GetX(), rect.GetMaxY() + 2, ..
            rect.GetWidth(), lines.length)
        ' TODO using the rect during init is getting in the way of refactoring
        service.currentMenuHandler = CTShowActionMenu.Create(menuFrameRect, lines)
        service.currentMenuHandler.delegate = service
        Return service
    End Function

    Method ShowMenu()
        Self.currentMenuHandler.ShowMenu()
    End Method

    '#Region CTShowActionMenuDelegate
    Method showActionMenuDidSelectMenuItem(showActionMenu:CTShowActionMenu, menuItem:CTMenuItem)
        If Self.currentMenuHandler <> showActionMenu Then Return
        ' Free up connection to subcomponent to break reference cycle
        Self.currentMenuHandler.delegate = Null
        Self.currentMenuHandler = Null

        Local action:String = menuItem.label
        mainLog.Append("ACTION: " + action)
        ' FIXME: Cannot call delegate with `Self.` prefix, see: <https://github.com/bmx-ng/bcc/issues/428>
        If Self.delegate Then delegate.SelectTokenDidSelectAction(Self, action)
    End Method
    '#End Region
End Type
