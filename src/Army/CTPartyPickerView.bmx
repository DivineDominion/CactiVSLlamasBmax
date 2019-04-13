SuperStrict

Import "../Game/CTPlayer.bmx"
Import "CTArmy.bmx"
Import "../View/CTControl.bmx"
Import "../View/CTSplitListView.bmx"
Import "../View/CTLabel.bmx"
Import "../View/CTViewport.bmx"
Import "../View/CTDialog.bmx"

Interface CTPartyPickerViewDelegate
    Method PartyPickerViewDidSelectParty(partyPickerView:CTPartyPickerView, selectedParty:TList)
End Interface

Type CTPartyPickerView Extends CTControl Implements CTSplitListViewDelegate, CTDialogDelegate
    Private
    Field army:CTArmy

    Field reserve:TList
    Field party:TList
    Field splitListView:CTSplitListView
    Field statusLabel:CTPartyStatusLabel
    Field confirmationActions:CTDialog


    '#REGION Creation
    Private
    Method New()
        Self.backgroundColor = CTColor.Black()
        Self.isOpaque = True
    End Method

    Public
    Const REQ_PARTY_COUNT:Int = 3
    Field delegate:CTPartyPickerViewDelegate = Null

    Method New(player:CTPlayer)
        New()

        ' Source model
        Self.army = player.army

        ' View model
        Self.reserve = New TList.FromArray(army.characters)
        Self.party = New TList()

        ' Subviews
        Self.splitListView = New CTSplitListView
        Self.splitListView.consumesKeyEvents = False
        Self.splitListView.delegate = Self
        Self.AddCharactersFromListToSide(Self.reserve, CTSplitListView.LEFT_SIDE)
        Self.AddCharactersFromListToSide(Self.party, CTSplitListView.RIGHT_SIDE)

        Self.statusLabel = CTPartyStatusLabel.Create()
        Self.UpdateStatusLabel()

        Self.confirmationActions = New CTDialog("Proceed", "Cancel")
        Self.confirmationActions.consumesKeyEvents = False
        Self.confirmationActions.delegate = Self
        Self.UpdateConfirmationActions()
    End Method

    Method TearDown()
        ResetDelegate()
        Self.splitListView.TearDown()
        Self.confirmationActions.TearDown()
        Super.TearDown()
    End Method

    Method ResetDelegate()
        Self.delegate = Null
    End Method

    Private
    Method AddCharactersFromListToSide(list:TList, side:Int)
        For Local character:CTCharacter = EachIn list
            Self.splitListView.AddMenuItemToSide(CTMenuItemFromCharacter(character), side)
        Next
    End Method

    Method UpdateStatusLabel()
        Self.statusLabel.DisplaySelectionCountOfRequired(Self.party.Count(), REQ_PARTY_COUNT)
    End Method

    Method UpdateConfirmationActions()
        Local isEnabled:Int = PartyIsFull()
        Self.confirmationActions.SetIsEnabledForIndex(isEnabled, 0)
    End Method
    '#End Region

    '#Region CTResponder
    ' Decorate responder stack access to the underlying controls
    Public
    Method MakeFirstResponder()
        Super.MakeFirstResponder()
        Self.splitListView.MakeFirstResponder()
    End Method

    Method ResignFirstResponder()
        Self.splitListView.ResignFirstResponder()
        Self.confirmationActions.ResignFirstResponder()
        Super.ResignFirstResponder()
    End Method

    Method RemoveFromResponderStack()
        Self.splitListView.RemoveFromResponderStack()
        Self.confirmationActions.RemoveFromResponderStack()
        Super.RemoveFromResponderStack()
    End Method
    '#End Region


    '#Region CTControl
    Public
    Method Cancel()
        Self.confirmationActions.SelectLast()
        Self.confirmationActions.MakeFirstResponder()
    End Method
    '#End Region


    '#Region CTDrawable
    Public
    Method Draw(dirtyRect:CTRect)
        Super.Draw(dirtyRect)

        ' Draw status at the top below window title
        Local labelRect:CTRect = dirtyRect.SettingHeight(statusLabel.GetTextHeight())
        CTViewport.Create(labelRect).Draw(statusLabel)

        ' Draw actions at the bottom
        Local lineHeight% = TextHeight("x")
        Local optionsRect:CTRect = dirtyRect..
            .SettingHeight(lineHeight)..
            .Translating(0, dirtyRect.GetHeight() - lineHeight)
        CTViewport.Create(optionsRect).Draw(confirmationActions)

        ' Draw list between status label and actions
        Local listRect:CTRect = dirtyRect..
            .Translating(0, labelRect.GetHeight())..
            .Resizing(0, -labelRect.GetHeight()-optionsRect.GetHeight())
        CTViewport.Create(listRect).Draw(splitListView)

        ' Draw separator
        CTColor.WindowFrameColor().Set()
        DrawRect 0, listRect.GetMaxY() - 4, listRect.GetMaxX(), 2
    End Method
    '#End Region


    '#Region CTSplitListViewDelegate
    Public
    Method SplitListViewDidSelectMenuItemFromSide(splitListView:CTSplitListView, menuItem:CTMenuItem, side:Int)
        SwitchCharacterFromMenuItemInSplitViewFromSide(menuItem, splitListView, side)
        UpdateStatusLabel()
        UpdateConfirmationActions()
    End Method

    Method SplitListViewDidActivateSide(splitListView:CTSplitListView, side:Int); End Method

    Method SplitListViewShouldWrapSide:Int(splitListView:CTSplitListView, side:Int, forwardDirection:Int)
        ' Instead of wrapping around in the list, jump to the options menu
        Self.confirmationActions.MakeFirstResponder()

        If side = CTSplitListView.LEFT_SIDE
            Self.confirmationActions.SelectFirst()
        ElseIf side = CTSplitListView.RIGHT_SIDE
            Self.confirmationActions.SelectLast()
        End If

        Return False
    End Method

    Private
    Method SwitchCharacterFromMenuItemInSplitViewFromSide(menuItem:CTMenuItem, splitListView:CTSplitListView, sourceSide:Int)
        Local sourceList:TList = CharacterListForSide(sourceSide)
        Local targetSide:Int = splitListView.OppositeOf(sourceSide)
        Local targetList:TList = CharacterListForSide(targetSide)

        If targetList = party And PartyIsFull() Then Return

        ' Update model
        Local transferredCharacterID:Int = menuItem.objectID
        Local character:CTCharacter = CharacterInListWithID(sourceList, transferredCharacterID)
        If Not character Then RuntimeError "No character found with ID " + String(transferredCharacterID)
        sourceList.Remove(character)
        targetList.AddLast(character)

        ' Update view
        splitListView.RemoveMenuItemFromSide(menuItem, sourceSide)
        splitListView.AddMenuItemToSide(CTMenuItemFromCharacter(character), targetSide)
    End Method

    Method CharacterListForSide:TList(side:Int)
        If side = CTSplitListView.LEFT_SIDE
            Return reserve
        ElseIf side = CTSplitListView.RIGHT_SIDE
            Return party
        EndIf
        RuntimeError "side " + String(side) + " is not supported"
    End Method

    Method PartyIsFull:Int()
        Return Self.party.Count >= REQ_PARTY_COUNT
    End Method
    '#End Region


    '#Region CTDialogDelegate
    Public
    Method DialogDidConfirm(dialog:CTDialog, didConfirm:Int)
        Local selectedParty:TList = Self.party
        If Not didConfirm Then selectedParty = Null

        ' FIXME: Cannot call delegate with `Self.` prefix, see: <https://github.com/bmx-ng/bcc/issues/428>
        If Self.delegate Then delegate.PartyPickerViewDidSelectParty(Self, selectedParty)
    End Method

    Method DialogShouldMoveVertically:Int(dialog:CTDialog)
        ' Move back to split view on vertical arrow keys
        Return True
    End Method

    Method DialogDidMoveVerticallyDownAtIndex(dialog:CTDialog, downwardDirection:Int, optionIndex:Int)
        Local side:Int = SplitViewSideForOptionIndex(optionIndex)
        If downwardDirection
            Self.splitListView.SelectFirstOnSide(side)
        Else
            Self.splitListView.SelectLastOnSide(side)
        End If
        Self.confirmationActions.ResignFirstResponder()
        Self.splitListView.ActivateListOnSide(side)
    End Method

    Private
    Method SplitViewSideForOptionIndex:Int(optionIndex:Int)
        If optionIndex = 0 Then Return CTSplitListView.LEFT_SIDE
        If optionIndex = 1 Then Return CTSplitListView.RIGHT_SIDE
        RuntimeError "Unexpected option index " + String(optionIndex)
    End Method
    '#End Region
End Type


Type CTPartyStatusLabel Extends CTLabel
    Function Create:CTPartyStatusLabel()
        Local label:CTPartyStatusLabel = New CTPartyStatusLabel()
        label.isCentered = True
        Return label
    End Function

    Method DisplaySelectionCountOfRequired(count:Int, required:Int)
        Self.text = "(" + String(count) + "/" + String(required) + " Members)"
        Self.isCentered = True
    End Method
End Type

Private
Function CharacterInListWithID:CTCharacter(characterList:TList, characterID:Int)
    For Local character:CTCharacter = EachIn characterList
        If character.GetID() = characterID Then Return character
    Next
    RuntimeError "No character found in TList with ID=" + String(characterID)
End Function

Function CTMenuItemFromCharacter:CTMenuItem(character:CTCharacter)
    Return New CTMenuItem(character.GetName(), character.GetID())
End Function
