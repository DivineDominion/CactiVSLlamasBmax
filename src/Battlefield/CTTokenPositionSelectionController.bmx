SuperStrict

Import "CTBattlefieldSelectionController.bmx"
Import "CTTokenPosition.bmx"

Interface CTTokenPositionSelectionControllerDelegate
    Method TokenPositionSelectionControllerDidSelectTokenPosition(controller:CTTokenPositionSelectionController, position:CTTokenPosition)
End Interface

Type CTTokenPositionSelectionController Extends CTBattlefieldSelectionController
    Public
    Field delegate:CTTokenPositionSelectionControllerDelegate = Null


    '#Region CTController
    Public
    Method TearDown()
        Self.RemoveDelegate()
        Super.TearDown()
    End Method

    Method RemoveDelegate()
        Self.delegate = Null
    End Method
    '#End Region


    '#Region CTKeyInterpreter
    Public
    Method ConfirmSelection()
        ' FIXME: Cannot call delegate with `Self.` prefix, see: <https://github.com/bmx-ng/bcc/issues/428>
        If Self.delegate Then delegate.TokenPositionSelectionControllerDidSelectTokenPosition(Self, Self.SelectedTokenPosition())
    End Method
    '#End Region
End Type
