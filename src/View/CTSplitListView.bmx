SuperStrict

Import "CTControl.bmx"
Import "CTMenu.bmx"
Import "CTViewport.bmx"

Interface CTSplitListViewDelegate
    Rem
    See CTSplitListView.LEFT_SIDE and CTSplitListView.RIGHT_SIDE for side values.
    End Rem
    Method SplitListViewDidSelectMenuItemFromSide(splitListView:CTSplitListView, menuItem:CTMenuItem, side:Int)

    Rem
    See CTSplitListView.LEFT_SIDE and CTSplitListView.RIGHT_SIDE for side values.
    End Rem
    Method SplitListViewDidActivateSide(splitListView:CTSplitListView, side:Int)
End Interface

Type CTSplitListView Extends CTControl Implements CTMenuDelegate
    Public
    Const LEFT_SIDE:Int = 0
    Const RIGHT_SIDE:Int = 1

    Private
    Field leftListMenu:CTMenu
    Field rightListMenu:CTMenu

    Public
    Field delegate:CTSplitListViewDelegate = Null

    Method New()
        Self.leftListMenu = New CTMenu()
        Self.leftListMenu.delegate = Self
        leftListMenu.AddMenuItemWithLabel("left")

        Self.rightListMenu = New CTMenu()
        rightListMenu.AddMenuItemWithLabel("Right")
        Self.rightListMenu.delegate = Self
    End Method

    Method AddMenuItemToSide(menuItem:CTMenuItem, side:Int)
        Self.ListForSide(side).AddMenuItem(menuItem)
    End Method

    Method TearDown()
        Self.leftListMenu.RemoveDelegate()
        Self.rightListMenu.RemoveDelegate()
    End Method

    Private
    Method ListForSide:CTMenu(side:Int)
        If side = CTSplitListView.LEFT_SIDE
            Return Self.leftListMenu
        Else
            Return Self.rightListMenu
        End If
    End Method

    '#Region CTKeyInterpreter and CTResponder Forwarding
    Public
    Method MakeFirstResponder()
        Super.MakeFirstResponder()
        Self.ActivateLeftList() ' Activate left list initially
    End Method

    Method MoveLeft()
        Self.ActivateLeftList()
    End Method

    Method MoveRight()
        Self.ActivateRightList()
    End Method

    Method ActivateLeftList()
        If Self.leftListMenu.IsEmpty() And Not Self.rightListMenu.IsEmpty()
            ActivateRightList()
            Return
        End If

        Self.rightListMenu.ResignFirstResponder()
        Self.leftListMenu.MakeFirstResponder()

        If Self.delegate
            Self.delegate.SplitListViewDidActivateSide(Self, CTSplitListView.LEFT_SIDE)
        End If
    End Method

    Method ActivateRightList()
        If Self.rightListMenu.IsEmpty() And Not Self.leftListMenu.IsEmpty()
            ActivateLeftList()
            Return
        End If

        Self.leftListMenu.ResignFirstResponder()
        Self.rightListMenu.MakeFirstResponder()

        If Self.delegate
            Self.delegate.SplitListViewDidActivateSide(Self, CTSplitListView.RIGHT_SIDE)
        End If
    End Method
    '#End Region


    '#Region CTMenuDelegate
    Method MenuDidSelectMenuItem(menu:CTMenu, menuItem:CTMenuItem)
        If Self.delegate
            Local side:Int = CTSplitListView.LEFT_SIDE
            If menu = rightListMenu Then side = CTSplitListView.RIGHT_SIDE
            Self.delegate.SplitListViewDidSelectMenuItemFromSide(Self, menuItem, side)
        End If
    End Method
    '#End Region

    '#Region CTDrawable
    Public
    Method Draw(dirtyRect:CTRect)
        Print("Draw SplitListView")
        Super.Draw(dirtyRect)

        Local columnWidth:Int = dirtyRect.GetWidth() / 2

        ' Left column
        Local leftColumnRect:CTRect = dirtyRect.SettingWidth(columnWidth)
        CTViewport.Create(leftColumnRect).Draw(leftListMenu)

        ' Right column
        Local rightColumnRect:CTRect = dirtyRect.SettingWidth(columnWidth).Translating(columnWidth, 0)
        CTViewport.Create(rightColumnRect).Draw(rightListMenu)
    End Method
    '#End Region
End Type
