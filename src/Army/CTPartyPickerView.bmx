SuperStrict

Import "../Game/CTPlayer.bmx"
Import "CTArmy.bmx"
Import "../View/CTControl.bmx"
Import "../View/CTMenu.bmx"
Import "../View/CTLabel.bmx"
Import "../View/CTViewport.bmx"

Type CTPartyPickerView Extends CTControl
    Private
    Field army:CTArmy

    Field reserve:TList
    Field reserveMenu:CTMenu

    Field party:TList
    Field partyMenu:CTMenu

    Field statusLabel:CTPartyStatusLabel

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
        Self.reserveMenu = Self.MenuForCharacterList(Self.reserve)
        Self.partyMenu = Self.MenuForCharacterList(Self.party)

        Self.statusLabel = CTPartyStatusLabel.Create()
        Self.statusLabel.DisplaySelectionCountOfRequired(Self.party.Count(), REQ_PARTY_COUNT)
    End Method

    Private
    Method MenuForCharacterList:CTMenu(list:TList)
        Local menu:CTMenu = New CTMenu
        For Local character:CTCharacter = EachIn list
            menu.AddMenuItemWithLabel(character.GetName())
        Next
        return menu
    End Method


    '#Region CTKeyInterpreter
    Public
    Method ConfirmSelection()
        Self.CurrentMenu().ConfirmSelection()
    End Method

    Method MoveUp()
        Self.CurrentMenu().MoveUp()
    End Method

    Method MoveDown()
        Self.CurrentMenu().MoveDown()
    End Method

    Method MoveLeft()
        Self.ActivateReserveMenu()
    End Method

    Method MoveRight()
        Self.ActivatePartyMenu()
    End Method

    Private
    Method CurrentMenu:CTMenu()
        If selectedColumn = 0 Then Return reserveMenu
        Return partyMenu
    End Method
    '#End Region

    Private
    Field selectedColumn:Int
    Field selectedRow:Int

    Method ActivateReserveMenu()
        If Self.reserveMenu.IsEmpty()
            ActivatePartyMenu()
            Return
        End If

        Self.selectedColumn = 0
    End Method

    Method ActivatePartyMenu()
        If Self.partyMenu.IsEmpty()
            ActivateReserveMenu()
            Return
        End If

        Self.selectedColumn = 1
    End Method

    '#Region CTDrawable
    Public
    Method Draw(dirtyRect:CTRect)
        Super.Draw(dirtyRect)

        Local columnWidth:Int = dirtyRect.GetWidth() / 2
        ' Left column
        Local leftColumnRect:CTRect = dirtyRect..
            .SettingWidth(columnWidth)..
            .Resizing(0, -statusLabel.GetTextHeight())
        CTViewport.Create(leftColumnRect).Draw(reserveMenu)

        ' Right column
        Local rightColumnRect:CTRect = dirtyRect..
            .SettingWidth(columnWidth)..
            .Translating(columnWidth, 0)..
            .Resizing(0, -statusLabel.GetTextHeight())
        CTViewport.Create(rightColumnRect).Draw(partyMenu)

        ' Draw status at the bottom
        Local labelRect:CTRect = dirtyRect..
            .SettingHeight(statusLabel.GetTextHeight())..
            .Translating(0, dirtyRect.GetHeight() - statusLabel.GetTextHeight())
        CTViewport.Create(labelRect).Draw(statusLabel)
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