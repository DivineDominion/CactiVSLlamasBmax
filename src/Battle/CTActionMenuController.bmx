SuperStrict

Import "../View/CTMenu.bmx"
Import "../View/CTController.bmx"
Import "CTActionable.bmx"

Interface CTActionMenuControllerDelegate
    Method ActionMenuControllerDidSelectAction(controller:CTActionMenuController, action:CTActionable)
    Method ActionMenuControllerDidCancel(controller:CTActionMenuController)
End Interface

Type CTActionMenuController Extends CTController Implements CTMenuDelegate
    Private
    Field actionMap:TIntMap
    Field menu:CTMenu

    Method New(); End Method

    Public
    Field delegate:CTActionMenuControllerDelegate = Null

    Method New(actions:CTActionable[])
        Self.menu = New CTMenu()
        Self.menu.delegate = Self
        Self.actionMap = New TIntMap()
        Self.InsertMenuItemsFromActions(actions)
    End Method

    Private
    Method InsertMenuItemsFromActions(actions:CTActionable[])
        Local i% = 1
        For Local action:CTActionable = EachIn actions
            If Not action
                Self.menu.AddMenuItem(CTMenuItem.CreateDivider())
            Else
                Self.actionMap.Insert(i, action)
                Self.menu.AddMenuItem(New CTMenuItem(action.GetLabel(), i))
            End If
            i :+ 1
        Next
    End Method


    '#Region CTController
    Public
    Method View:CTView()
        Return Self.menu
    End Method

    Method TearDown()
        Self.RemoveDelegate()
        Super.TearDown()
    End Method

    Method RemoveDelegate()
        Self.delegate = Null
    End Method
    '#End Region


    '#Region CTMenuDelegate
    Public
    Method MenuDidSelectMenuItem(menu:CTMenu, menuItem:CTMenuItem)
        If Self.menu <> menu Then Return
        Local action:CTActionable = Self.ActionForMenuItem(menuItem)
        If action = Null Then Return
        ' FIXME: Cannot call delegate with `Self.` prefix, see: <https://github.com/bmx-ng/bcc/issues/428>
        If Self.delegate Then delegate.ActionMenuControllerDidSelectAction(Self, action)
    End Method

    Method MenuShouldWrapAround:Int(menu:CTMenu, forwardDirection:Int)
        Return True
    End Method

    Method MenuDidCancel(menu:CTMenu)
        If Self.delegate Then delegate.ActionMenuControllerDidCancel(Self)
    End Method

    Private
    Method ActionForMenuItem:CTActionable(menuItem:CTMenuItem)
        If menuItem.objectID = CTMenuItem.NO_OBJECT Then Return Null
        Local action:CTActionable = CTActionable(Self.actionMap.ValueForKey(menuItem.objectID))
        Return action
    End Method
    '#End Region
End Type
