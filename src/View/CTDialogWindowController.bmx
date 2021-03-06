SuperStrict

Import "CTWindowController.bmx"
Import "CTDialog.bmx"
Import "CTWindowManager.bmx"
Import "CTRect.bmx"
Import "CTScreen.bmx"

Interface CTDialogWindowControllerDelegate
    Method DialogWindowControllerDidConfirm(controller:CTDialogWindowController, didConfirm:Int)
End Interface

Type CTDialogWindowController Extends CTWindowController Implements CTDialogDelegate
    Private
    Field title:String
    Field dialog:CTDialog

    Method New(); End Method


    Public
    Method New(confirmLabel:String = "OK", cancelLabel:String = "Cancel", title:String = Null)
        Self.dialog = New CTDialog(confirmLabel, cancelLabel)
        Self.title = title
    End Method


    '#Region Dialog currentWindow lifecycle
    Private
    Field delegate:CTDialogWindowControllerDelegate = Null

    Public
    Method ShowDialog()
        ShowDialogWithDelegate(Null)
    End Method

    Method ShowDialogWithDelegate(delegate:CTDialogWindowControllerDelegate)
        Assert Not currentWindow Else "#ShowDialogWithDelegate cannot be called while currentWindow is shown"

        ' Works without delegate. Still block the UI with the dialog options.
        Self.delegate = delegate
        Self.dialog.delegate = Self ' Note: creates cycle

        Local offset:Int = 20
        Local width:Int = CTScreen.main.GetWidth() - (offset * 2)
        Local frameRect:CTRect = CTWindow.FrameRectFittingLinesAndTitle(offset, 0, width, 1, Self.title)
        Self.currentWindow = CTWindow.Create(frameRect, Self.dialog, Self.title)
        Self.currentWindow.Center()
        CTWindowManager.GetInstance().AddWindowAndMakeKey(Self.currentWindow)
    End Method

    Method CloseDialog()
        Self.delegate = Null
        Self.dialog.delegate = Null ' Break cycle
        CTWindowManager.GetInstance().RemoveWindow(Self.currentWindow)
    End Method
    '#End Region


    '#Region CTDialogDelegate
    Public
    Method DialogDidConfirm(dialog:CTDialog, didConfirm:Int)
        If Self.dialog <> dialog Then Return
        ' FIXME: Cannot call delegate with `Self.` prefix, see: <https://github.com/bmx-ng/bcc/issues/428>
        If Self.delegate Then delegate.DialogWindowControllerDidConfirm(Self, didConfirm)
        ' End of the selection process closes dialog automatically
        CloseDialog()
    End Method

    Method DialogShouldMoveVertically:Int(dialog:CTDialog)
        Return False
    End Method

    Method DialogDidMoveVerticallyDownAtIndex(dialog:CTDialog, downwardDirection:Int, optionIndex:Int)
        ' no op
    End Method
    '#End Region
End Type
