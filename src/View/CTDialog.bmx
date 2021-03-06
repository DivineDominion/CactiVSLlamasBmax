SuperStrict

Import "CTControl.bmx"
Import "CTMenu.bmx"

Interface CTDialogDelegate
    Method DialogDidConfirm(dialog:CTDialog, didConfirm:Int)

    Rem
    returns: True if vertical movement should be handled, False otherwise.
    End Rem
    Method DialogShouldMoveVertically:Int(dialog:CTDialog)

    Rem
    Called when the user pressed up/down arrow keys while the dialog is active.
    Dialogs are presented horizontally, so use this to switch to detail elements.
    EndRem
    Method DialogDidMoveVerticallyDownAtIndex(dialog:CTDialog, downwardDirection:Int, optionIndex:Int)
End Interface

Type CTDialog Extends CTControl Implements CTMenuDelegate
    Private
    Field menu:CTMenu
    Field confirmMenuItem:CTMenuItem
    Field cancelMenuItem:CTMenuItem


    Public
    Field delegate:CTDialogDelegate = Null

    Method New(confirmLabel:String = "OK", cancelLabel:String = "Cancel")
        Self.confirmMenuItem:CTMenuItem = New CTMenuItem(confirmLabel)
        Self.cancelMenuItem:CTMenuItem = New CTMenuItem(cancelLabel)

        Self.menu = New CTMenu([], True)
        Self.menu.AddMenuItem(confirmMenuItem)
        Self.menu.AddMenuItem(cancelMenuItem)
        Self.menu.consumesKeyEvents = False
        Self.menu.delegate = Self
    End Method

    Method TearDown()
        RemoveDelegate()
        Self.menu.TearDown()
        Super.TearDown()
    End Method

    Method RemoveDelegate()
        Self.delegate = Null
    End Method


    '#Region CTMenu Decorator
    Public
    Method SelectFirst()
        Self.menu.SelectFirst()
    End Method

    Method SelectLast()
        Self.menu.SelectLast()
    End Method

    Method SetIsEnabledForIndex(isEnabled:Int, index:Int)
        Self.menu.SetIsEnabledForIndex(isEnabled, index)
    End Method
    '#End Region


    '#Region CTDrawable
    Public
    Method DrawInterior(dirtyRect:CTRect)
        Super.DrawInterior(dirtyRect)
        Self.menu.Draw(dirtyRect)
    End Method
    '#End Region


    '#Region CTResponder
    ' Decorate responder stack access to the underlying menu
    Method MakeFirstResponder()
        Super.MakeFirstResponder()
        Self.menu.MakeFirstResponder()
    End Method

    Method ResignFirstResponder()
        Self.menu.ResignFirstResponder()
        Super.ResignFirstResponder()
    End Method

    Method RemoveFromResponderStack()
        Self.menu.RemoveFromResponderStack()
        Super.RemoveFromResponderStack
    End Method
    '#End Region


    '#Region CTKeyInterpreter
    Public
    Method MoveUp()
        If ShouldMoveVertically() Then NotifyMoveDown(False)
    End Method

    Method MoveDown()
        If ShouldMoveVertically() Then NotifyMoveDown(True)
    End Method

    Private
    Method ShouldMoveVertically:Int()
        If Not Self.delegate Then Return False
        ' FIXME: Cannot call delegate with `Self.` prefix, see: <https://github.com/bmx-ng/bcc/issues/428>
        Return delegate.DialogShouldMoveVertically(Self)
    End Method

    Method NotifyMoveDown(downwardDirection:Int)
        ' FIXME: Cannot call delegate with `Self.` prefix, see: <https://github.com/bmx-ng/bcc/issues/428>
        delegate.DialogDidMoveVerticallyDownAtIndex(Self, downwardDirection, SelectionIndex())
    End Method

    Method SelectionIndex:Int()
        If menu.GetSelectedMenuItem() = confirmMenuItem Then Return 0
        Return 1
    End Method
    '#End Region


    '#Region CTMenuDelegate
    Public
    Method MenuDidSelectMenuItem(menu:CTMenu, menuItem:CTMenuItem)
        Assert menu = Self.menu Else "CTDialog callback called with wrong menu"
        Local didConfirm:Int = (menuItem <> Self.cancelMenuItem)
        ' FIXME: Cannot call delegate with `Self.` prefix, see: <https://github.com/bmx-ng/bcc/issues/428>
        If Self.delegate Then delegate.DialogDidConfirm(Self, didConfirm)
    End Method

    Method MenuDidCancel(menu:CTMenu)
        Self.SelectLast()
    End Method

    Method MenuShouldWrapAround:Int(menu:CTMenu, forwardDirection:Int)
        Return True
    End Method
    '#End Region
End Type
