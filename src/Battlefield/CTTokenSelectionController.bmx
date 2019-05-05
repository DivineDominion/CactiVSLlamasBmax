SuperStrict

Import "CTBattlefieldSelectionController.bmx"
Import "CTBattlefield.bmx"
Import "CTTokenPosition.bmx"

Interface CTTokenSelectionControllerDelegate
    Method TokenSelectionControllerFilterDeadCharacters:Int(controller:CTTokenSelectionController)
    Method TokenSelectionControllerDidChangeHighlightedToken(controller:CTTokenSelectionController, token:CTToken)
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

    ' See `CTBattlefieldSelectionController`: overriding abstract initializers doesn't work
    ' Method New(battlefield:CTBattlefield, initialTokenPosition:CTTokenPosition = Null)
'         Super.New(initialTokenPosition)
'         ' FIXME: use extra init method from constructor because of: https://github.com/bmx-ng/bcc/issues/417
'         _Initialize(initialTokenPosition)
'
'         Self.battlefield = battlefield
'     End Method

    Function Create:CTTokenSelectionController(battlefield:CTBattlefield, initialTokenPosition:CTTokenPosition = Null)
        Local controller:CTTokenSelectionController = New CTTokenSelectionController()
        ' FIXME: use extra init method from constructor because of: https://github.com/bmx-ng/bcc/issues/417
        controller.battlefield = battlefield
        controller._Initialize(initialTokenPosition)
        Return controller
    End Function

    Method SelectedTokenInBattlefield:CTToken()
        Return Self.battlefield.TokenAtPosition(Self.SelectedTokenPosition())
    End Method

    Method TokenSelectionDidMove() Override
        ' FIXME: Cannot call delegate with `Self.` prefix, see: <https://github.com/bmx-ng/bcc/issues/428>
        If Self.delegate Then delegate.TokenSelectionControllerDidChangeHighlightedToken(Self, Self.SelectedTokenInBattlefield())
    End Method


    '#Region CTKeyInterpreter
    Public
    Method ConfirmSelection()
        If Not Self.delegate Then Return
        ' FIXME: Cannot call delegate with `Self.` prefix, see: <https://github.com/bmx-ng/bcc/issues/428>
        Local selectedToken:CTToken = SelectedTokenInBattlefield()
        If Not selectedToken Then Return
        If delegate.TokenSelectionControllerFilterDeadCharacters(Self) And Not selectedToken.CharacterIsAlive() Then Return
        delegate.TokenSelectionControllerDidSelectToken(Self, selectedToken)
    End Method
    '#End Region
End Type
