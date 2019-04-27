SuperStrict

Import "../View/CTWindowManager.bmx"
Import "../View/CTDialogWindowController.bmx"
Import "../Army/CTParty.bmx"
Import "../Battlefield/CTBattlefield.bmx"
Import "../Battlefield/CTBattlefieldWindowController.bmx"
Import "../Battlefield/CTTokenFactory.bmx"
Import "CTPartyPlacementStatusWindowController.bmx"
Import "CTSelectCharacterFromParty.bmx"

Interface CTPlacePartyDelegate
    Method PlacePartyDidPrepareBattlefield(controller:CTPlacePartyCoordinator, battlefield:CTBattlefield)
End Interface

Rem
Puts multiple windows on the screen and manages the selection and placement of
tokens on the battlefield.
End Rem
Type CTPlacePartyCoordinator ..
Implements CTTokenPositionSelectionControllerDelegate, ..
           CTSelectCharacterFromPartyDelegate, ..
           CTDialogWindowControllerDelegate

    Private
    Field frameRect:CTRect
    Field party:CTParty
    Field battlefield:CTBattlefield

    Method New(); End Method

    Public
    Method New(frameRect:CTRect, party:CTParty)
        Assert frameRect Else "CTPlacePartyCoordinator requires frameRect"
        Assert party Else "CTPlacePartyCoordinator requires party"

        Self.frameRect = frameRect
        Self.party = party
        Self.battlefield = New CTBattlefield()
    End Method


    '#Region Window lifecycle management
    Private
    Field delegate:CTPlacePartyDelegate = Null
    Field battlefieldWindowController:CTBattlefieldWindowController = Null
    Field statusWindowController:CTPartyPlacementStatusWindowController = Null
    Field selectionSession:Object = Null

    Public
    Method ShowPartyPlacement(delegate:CTPlacePartyDelegate)
        Assert delegate Else "#ShowPartyPlacement requires delegate"
        Assert Not Self.battlefieldWindowController And Not Self.statusWindowController Else "#ShowPartyPlacement called before closing the window"

        Self.delegate = delegate

        Self.battlefieldWindowController = New CTBattlefieldWindowController(Self.frameRect, Self.battlefield)
        Self.battlefieldWindowController.Show()

        Self.statusWindowController = New CTPartyPlacementStatusWindowController(Self.frameRect, Self.party.Count())
        Self.statusWindowController.Show()

        ' Start selecting
        Self.selectionSession = Self.battlefieldWindowController.StartSelectingTokenPositionWithDelegate(Self)
    End Method

    Method CloseWindows()
        Assert Self.battlefieldWindowController Else "#CloseWindows called without active battlefieldWindowController"
        Assert Self.statusWindowController Else "#CloseWindows called without active statusWindowController"

        Self.battlefieldWindowController.Close()
        Self.battlefieldWindowController = Null

        Self.statusWindowController.Close()
        Self.statusWindowController = Null

        Self.delegate = Null
    End Method
    '#End Region


    '#Region CTTokenPositionSelectionControllerDelegate
    Private
    Field characterSelection:CTSelectCharacterFromParty = Null
    Field currentSelectedPositon:CTTokenPosition = Null

    Public
    Method TokenPositionSelectionControllerDidSelectTokenPosition(controller:CTTokenPositionSelectionController, position:CTTokenPosition)
        Assert Not Self.characterSelection Else "Expected characterSelection to be Null"
        Self.currentSelectedPositon = position
        Self.characterSelection = New CTSelectCharacterFromParty(Self.party, Self.CharactersPlacedOnBattlefield())
        Self.characterSelection.Show(Self)
    End Method

    Private
    Method CharactersPlacedOnBattlefield:TList()
        Local result:TList = New TList()
        For Local token:CTToken = EachIn Self.battlefield.AllTokens()
            result.AddLast(token.GetCharacter())
        Next
        Return result
    End Method

    Method CloseCharacterSelection()
        Self.characterSelection.Close()
        Self.characterSelection = Null
        Self.currentSelectedPositon = Null
    End Method
    '#End Region


    '#Region CTSelectCharacterFromPartyDelegate
    Public
    Method SelectCharacterFromPartyDidSelectCharacter(service:CTSelectCharacterFromParty, character:CTCharacter)
        Assert Self.currentSelectedPositon Else "Expected currentSelectedPositon to be set while selecting characters"
        PlaceCharacterAtPosition(character, Self.currentSelectedPositon)
        UpdateWindowControllers()
        CloseCharacterSelection()
        ShowConfirmationIfPossible()
    End Method

    Method SelectCharacterFromPartyDidCancel(service:CTSelectCharacterFromParty)
        CloseCharacterSelection()
    End Method

    Private
    Method PlaceCharacterAtPosition(character:CTCharacter, currentSelectedPositon:CTTokenPosition)
        Local existingPosition:CTTokenPosition = TokenPositionOfCharacter(character)
        If existingPosition
            Self.battlefield.RemoveTokenAtPosition(existingPosition)
        End If

        Local token:CTToken = CTTokenFromCharacter(character)
        Self.battlefield.PutTokenAtPosition(token, Self.currentSelectedPositon)
    End Method

    Method TokenPositionOfCharacter:CTTokenPosition(character:CTCharacter)
        For Local node:TKeyValue = EachIn Self.battlefield.TokenPositionsTokens()
            Local currentPosition:CTTokenPosition = CTTokenPosition(node.Key())
            Local currentCharacter:CTCharacter = CTToken(node.Value()).GetCharacter()
            If currentCharacter = character Then Return currentPosition
        Next
        Return Null
    End Method

    Method UpdateWindowControllers()
        Self.battlefieldWindowController.UpdateBattlefield()
        Local tokenCount:Int = Self.battlefield.AllTokens.Count()
        Self.statusWindowController.UpdatePlacementCount(tokenCount)
    End Method
    '#End Region


    '#Region Confirmation
    Private
    Field confirmationDialog:CTDialogWindowController = Null

    Public
    Method ShowConfirmationIfPossible()
        If Not HasPlacedAllPartyMembers() Then Return
        ShowConfirmationDialog()
    End Method

    Private
    Method HasPlacedAllPartyMembers:Int()
        Local tokenCount:Int = Self.battlefield.AllTokens.Count()
        Local partyCount:Int = Self.party.Count()
        Return tokenCount >= partyCount
    End Method

    Method ShowConfirmationDialog()
        Assert Not Self.confirmationDialog Else "Expected #ShowConfirmationDialog to be called without active dialog"
        Self.confirmationDialog = New CTDialogWindowController("Confirm", "Modify", "Use this party placement?")
        Self.confirmationDialog.ShowDialogWithDelegate(Self)
    End Method
    '#End Region


    '#Region CTDialogWindowControllerDelegate to handle placement confirmation
    Public
    Method DialogWindowControllerDidConfirm(controller:CTDialogWindowController, didConfirm:Int)
        If Self.confirmationDialog <> controller Then Return
        Self.confirmationDialog = Null

        If Not didConfirm Then Return
        ' FIXME: Cannot call delegate with `Self.` prefix, see: <https://github.com/bmx-ng/bcc/issues/428>
        If Self.delegate Then delegate.PlacePartyDidPrepareBattlefield(Self, Self.battlefield)
    End Method
    '#End Region
End Type
