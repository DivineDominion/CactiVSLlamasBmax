SuperStrict

Import "CTShowActionMenu.bmx"
Import "CTToken.bmx"
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

    Method New(token:CTToken, rect:CTRect)
        Local character:CTCharacter = token.GetCharacter()
        Local lines:String[] = ["Fight", "Move", "", "Run"]
        Local menuFrameRect:CTRect = CTWindow.FrameRectFittingLinesAndTitle(..
            rect.GetX(), rect.GetMaxY() + 2, ..
            rect.GetWidth(), lines.length)
        ' TODO using the rect during init is getting in the way of refactoring
        Self.currentMenuHandler = New CTShowActionMenu(menuFrameRect, lines, character.GetName())
    End Method

    Method ShowMenu()
        Self.currentMenuHandler.ShowMenu()
    End Method

    '#Region CTShowActionMenuDelegate
    Method ShowActionMenuDidSelectAction(showActionMenu:CTShowActionMenu, action:String)
        If Self.currentMenuHandler <> showActionMenu Then Return
        ' Free up connection to subcomponent to break reference cycle
        Self.currentMenuHandler.delegate = Null
        Self.currentMenuHandler = Null

        mainLog.Append("ACTION: " + action)
        ' FIXME: Cannot call delegate with `Self.` prefix, see: <https://github.com/bmx-ng/bcc/issues/428>
        If Self.delegate Then delegate.SelectTokenDidSelectAction(Self, action)
    End Method
    '#End Region
End Type
