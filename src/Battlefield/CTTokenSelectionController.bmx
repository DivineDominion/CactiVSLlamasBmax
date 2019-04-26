SuperStrict

Import "CTBattlefieldSelectionController.bmx"
Import "CTBattlefield.bmx"
Import "CTTokenPosition.bmx"

Interface CTTokenSelectionControllerDelegate
    Method TokenSelectionControllerDidSelectToken(controller:CTTokenSelectionController, token:CTToken)
End Interface

Rem
Controller that filters selections on the battlefield by tokens at the cursor position.
Ignores unoccupied tiles on the battlefield.
End Rem
Type CTTokenSelectionController Extends CTBattlefieldSelectionController
    Private
    Field battlefield:CTBattlefield

    Public
    Field delegate:CTTokenSelectionControllerDelegate = Null

    Method New(battlefield:CTBattlefield, initialTokenPosition:CTTokenPosition = Null)
        Super.New(initialTokenPosition)
        ' FIXME: use extra init method from constructor because of: https://github.com/bmx-ng/bcc/issues/417
        Initialize(initialTokenPosition)

        Self.battlefield = battlefield
    End Method

    Method SelectedTokenInBattlefield:CTToken()
        Return Self.battlefield.TokenAtPosition(Self.SelectedTokenPosition())
    End Method

    '#Region CTKeyInterpreter
    Public
    Method ConfirmSelection()
        If Not Self.delegate Then Return
        ' FIXME: Cannot call delegate with `Self.` prefix, see: <https://github.com/bmx-ng/bcc/issues/428>
        Local selectedToken:CTToken = SelectedTokenInBattlefield()
        If selectedToken Then delegate.TokenSelectionControllerDidSelectToken(Self, selectedToken)
    End Method
    '#End Region
End Type
