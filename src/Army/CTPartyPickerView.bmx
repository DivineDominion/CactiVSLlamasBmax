SuperStrict

Import "../Game/CTPlayer.bmx"
Import "CTArmy.bmx"
Import "../View/CTControl.bmx"
Import "../View/CTSplitListView.bmx"
Import "../View/CTLabel.bmx"
Import "../View/CTViewport.bmx"

Type CTPartyPickerView Extends CTControl Implements CTSplitListViewDelegate
    Private
    Field army:CTArmy

    Field reserve:TList
    Field party:TList
    Field splitListView:CTSplitListView

    Field statusLabel:CTPartyStatusLabel


    '#REGION Creation
    Private
    Method New()
        Self.backgroundColor = CTColor.Black()
        Self.isOpaque = True
    End Method

    Public
    Const REQ_PARTY_COUNT:Int = 3

    Method New(player:CTPlayer)
        New()

        ' Source model
        Self.army = player.army

        ' View model
        Self.reserve = New TList.FromArray(army.characters)
        Self.party = New TList()

        ' Subviews
        Self.splitListView = New CTSplitListView
        Self.splitListView.delegate = Self
        Self.AddCharactersFromListToSide(Self.reserve, CTSplitListView.LEFT_SIDE)
        Self.AddCharactersFromListToSide(Self.party, CTSplitListView.RIGHT_SIDE)

        Self.statusLabel = CTPartyStatusLabel.Create()
        UpdateStatusLabel()
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
    '#End Region


    Public
    Method MakeFirstResponder()
        Super.MakeFirstResponder()
        Self.splitListView.MakeFirstResponder()
    End Method


    '#Region CTDrawable
    Public
    Method Draw(dirtyRect:CTRect)
        Super.Draw(dirtyRect)

        ' Draw status at the bottom
        Local labelRect:CTRect = dirtyRect..
            .SettingHeight(statusLabel.GetTextHeight())..
            .Translating(0, dirtyRect.GetHeight() - statusLabel.GetTextHeight())
        CTViewport.Create(labelRect).Draw(statusLabel)

        ' Draw list above status label
        Local listRect:CTRect = dirtyRect.Resizing(0, -statusLabel.GetTextHeight())
        CTViewport.Create(listRect).Draw(splitListView)
    End Method
    '#End Region


    '#Region CTSplitListViewDelegate
    Public
    Method SplitListViewDidSelectMenuItemFromSide(splitListView:CTSplitListView, menuItem:CTMenuItem, side:Int)
        SwitchCharacterFromMenuItemInSplitViewFromSide(menuItem, splitListView, side)
        UpdateStatusLabel()
    End Method

    Method SplitListViewDidActivateSide(splitListView:CTSplitListView, side:Int); End Method

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
