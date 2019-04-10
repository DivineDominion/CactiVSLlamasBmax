SuperStrict

Import "CTControl.bmx"
Import "CTMenu.bmx"

Interface CTDialogDelegate
    Method DialogDidConfirm(dialog:CTDialog, didConfirm:Int)
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

    Method Draw(dirtyRect:CTRect)
        Super.Draw(dirtyRect)
        Self.menu.Draw(dirtyRect)
    End Method


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


    '#Region CTMenuDelegate
    Public
    Method MenuDidSelectMenuItem(menu:CTMenu, menuItem:CTMenuItem)
        Assert menu = Self.menu Else "CTDialog callback called with wrong menu"
        Local didConfirm:Int = (menuItem <> Self.cancelMenuItem)
        ' FIXME: Cannot call delegate with `Self.` prefix, see: <https://github.com/bmx-ng/bcc/issues/428>
        If Self.delegate Then delegate.DialogDidConfirm(Self, didConfirm)
    End Method

    Method MenuShouldWrapAround:Int(menu:CTMenu, forwardDirection:Int)
        Return True
    End Method
    '#End Region
End Type
