SuperStrict

Import "CTControl.bmx"
Import "CTMenu.bmx"
Import "CTViewport.bmx"

Interface CTSplitListViewDelegate
    Rem
    See CTSplitListView.LEFT_SIDE and CTSplitListView.RIGHT_SIDE for side values.
    End Rem
    Method SplitListViewDidSelectMenuItemFromSide(splitListView:CTSplitListView, menuItem:CTMenuItem, side:Int)
    Method SplitListViewDidCancel(splitListView:CTSplitListView)

    Method SplitListViewShouldWrapSide:Int(splitListView:CTSplitListView, side:Int, forwardDirection:Int)

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
        Self.leftListMenu = New CTMenu([])
        Self.leftListMenu.delegate = Self

        Self.rightListMenu = New CTMenu([])
        Self.rightListMenu.delegate = Self

        ' Bubble up key events from menus to this control but no further
        Self.leftListMenu.consumesKeyEvents = False
        Self.rightListMenu.consumesKeyEvents = False
        Self.consumesKeyEvents = True
    End Method

    Method TearDown()
        RemoveDelegate()
        Self.leftListMenu.TearDown()
        Self.rightListMenu.TearDown()
        Super.TearDown()
    End Method

    Method RemoveDelegate()
        Self.delegate = Null
    End Method

    Method OppositeOf:Int(side:Int)
        If side = LEFT_SIDE
            Return RIGHT_SIDE
        ElseIf side = RIGHT_SIDE
            Return LEFT_SIDE
        End If
        RuntimeError "side " + String(side) + " is not supported"
    End Method

    Method SelectFirstOnSide(side:Int)
        ListForSide(side).SelectFirst()
    End Method

    Method SelectLastOnSide(side:Int)
        ListForSide(side).SelectLast()
    End Method

    Method ActivateListOnSide(side:Int)
        Local list:CTMenu = ListForSide(side)
        Local oppositeSide:Int = OppositeOf(side)
        Local oppositeList:CTMenu = ListForSide(oppositeSide)

        ' Activate opposite list instead if this one is empty
        If list.IsEmpty() And Not oppositeList.IsEmpty()
            ActivateListOnSide(oppositeSide)
            Return
        End If

        oppositeList.ResignFirstResponder()
        list.MakeFirstResponder()

        ' FIXME: Cannot call delegate with `Self.` prefix, see: <https://github.com/bmx-ng/bcc/issues/428>
        If Self.delegate Then delegate.SplitListViewDidActivateSide(Self, side)
    End Method


    '#Region Split View Contents
    Public
    Method RemoveMenuItemFromSide(menuItem:CTMenuItem, side:Int)
        Local list:CTMenu = ListForSide(side)
        list.RemoveMenuItem(menuItem)

        ' When removing the last item from the current list, switch focus to the opposite side
        If IsFirstResponder(list) And list.IsEmpty()
            If list = leftListMenu Then ActivateListOnSide(LEFT_SIDE)
            If list = rightListMenu Then ActivateListOnSide(RIGHT_SIDE)
        End If
    End Method

    Method AddMenuItemToSide(menuItem:CTMenuItem, side:Int)
        Self.ListForSide(side).AddMenuItem(menuItem)
    End Method


    Private
    Method ListForSide:CTMenu(side:Int)
        If side = CTSplitListView.LEFT_SIDE
            Return Self.leftListMenu
        ElseIf side = CTSplitListView.RIGHT_SIDE
            Return Self.rightListMenu
        End If
        RuntimeError "side " + String(side) + " is not supported"
    End Method
    '#End Region


    '#Region CTKeyInterpreter and CTResponder Forwarding
    Public
    Method MakeFirstResponder()
        Super.MakeFirstResponder()
        Self.ActivateListOnSide(LEFT_SIDE)
    End Method

    Method MoveLeft()
        Self.ActivateListOnSide(LEFT_SIDE)
    End Method

    Method MoveRight()
        Self.ActivateListOnSide(RIGHT_SIDE)
    End Method
    '#End Region


    '#Region CTMenuDelegate
    Method MenuDidSelectMenuItem(menu:CTMenu, menuItem:CTMenuItem)
        If Self.delegate
            Local side:Int = CTSplitListView.LEFT_SIDE
            If menu = rightListMenu Then side = CTSplitListView.RIGHT_SIDE
            ' FIXME: Cannot call delegate with `Self.` prefix, see: <https://github.com/bmx-ng/bcc/issues/428>
            delegate.SplitListViewDidSelectMenuItemFromSide(Self, menuItem, side)
        End If
    End Method

    Method MenuShouldWrapAround:Int(menu:CTMenu, forwardDirection:Int)
        If Not Self.delegate Then Return True
        ' FIXME: Cannot call delegate with `Self.` prefix, see: <https://github.com/bmx-ng/bcc/issues/428>
        Return delegate.SplitListViewShouldWrapSide(Self, SideForMenu(menu), forwardDirection)
    End Method

    Method MenuDidCancel(menu:CTMenu)
        ' FIXME: Cannot call delegate with `Self.` prefix, see: <https://github.com/bmx-ng/bcc/issues/428>
        If Self.delegate Then delegate.SplitListViewDidCancel(Self)
    End Method

    Private
    Method SideForMenu:Int(menu:CTMenu)
        If menu = leftListMenu
            Return CTSplitListView.LEFT_SIDE
        Else If menu = rightListMenu
            Return CTSplitListView.RIGHT_SIDE
        End If
        RuntimeError "Attempting to get side from unknown menu"
    End Method
    '#End Region


    '#Region CTDrawable
    Public
    Method Draw(dirtyRect:CTRect)
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
