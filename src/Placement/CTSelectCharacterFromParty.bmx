SuperStrict

Import "../View/CTWindowManager.bmx"
Import "../View/CTMenu.bmx"
Import "../View/CTScreen.bmx"
Import "../Army/CTParty.bmx"
Import "../Army/CTMenuItemFromCharacter.bmx"

Interface CTSelectCharacterFromPartyDelegate
    Method SelectCharacterFromPartyDidSelectCharacter(service:CTSelectCharacterFromParty, character:CTCharacter)
    Method SelectCharacterFromPartyDidCancel(service:CTSelectCharacterFromParty)
End Interface

Type CTSelectCharacterFromParty Implements CTMenuDelegate
    Private
    Field party:CTParty
    Field selectedCharacters:TList

    Method New(); End Method


    Public
    Method New(party:CTParty, selectedCharacters:TList)
        Self.party = party
        Self.selectedCharacters = selectedCharacters
    End Method


    '#Region Selection lifecycle
    Private
    Field delegate:CTSelectCharacterFromPartyDelegate = Null
    Field currentWindow:CTWindow = Null
    Field menu:CTMenu = Null

    Public
    Method Show(delegate:CTSelectCharacterFromPartyDelegate)
        Assert delegate Else "#Show requires delegate"
        Assert Not Self.currentWindow Else "#Show called with active window"

        Self.delegate = delegate

        Local characters:CTCharacter[] = Self.party.Characters()
        Self.menu = CTMenuForCharactersWithSelectedCharacters(characters, selectedCharacters)
        Self.menu.delegate = Self
        Self.menu.SelectFirstUncheckedMenuItem()

        Local menuWidth:Int = MaxCharacterNameWidthForCharacters(characters) + Self.menu.GetLineLabelOffset()
        Local menuHeight:Int = characters.length * TextHeight("x")
        Local contentBounds:CTRect = CTRect.Create(0, 0, menuWidth, menuHeight)
        Local frameRect:CTRect = CTWindow..
            .FrameRectFittingContentRect(contentBounds)..
            .CenteringInContainer(CTScreen.main.GetBounds())
        Self.currentWindow = CTWindow.Create(frameRect, menu)
        CTWindowManager.GetInstance().AddWindowAndMakeKey(Self.currentWindow)
    End Method

    Method Close()
        Assert Self.currentWindow Else "#Close called without active window"
        CTWindowManager.GetInstance().RemoveWindow(Self.currentWindow)
        Self.currentWindow = Null
        Self.menu = Null
        Self.delegate = Null
    End Method
    '#End Region


    '#Region CTMenuDelegate
    Public
    Method MenuDidSelectMenuItem(menu:CTMenu, menuItem:CTMenuItem)
        Local selectedCharacter:CTCharacter = Self.party.CharacterWithID(menuItem.objectID)
        Assert selectedCharacter Else "Expected CTSelectCharacterFromParty menu to return character via ID"
        ' FIXME: Cannot call delegate with `Self.` prefix, see: <https://github.com/bmx-ng/bcc/issues/428>
        If Self.delegate Then delegate.SelectCharacterFromPartyDidSelectCharacter(Self, selectedCharacter)
    End Method

    Method MenuDidCancel(menu:CTMenu)
        ' FIXME: Cannot call delegate with `Self.` prefix, see: <https://github.com/bmx-ng/bcc/issues/428>
        If Self.delegate Then delegate.SelectCharacterFromPartyDidCancel(Self)
    End Method

    Method MenuShouldWrapAround:Int(menu:CTMenu, forwardDirection:Int)
        Return True
    End Method
    '#End Region
End Type

Private
Function CTMenuForCharactersWithSelectedCharacters:CTMenu(characters:CTCharacter[], selectedCharacters:TList)
    Local menu:CTMenu = New CTMenu()
    menu.displaysCheckmarks = True
    For Local character:CTCharacter = EachIn characters
        Local menuItem:CTMenuItem = CTMenuItemFromCharacter(character)
        If selectedCharacters.Contains(character) Then menuItem.isChecked = True
        menu.AddMenuItem(menuItem)
    Next
    Return menu
End Function

Function MaxCharacterNameWidthForCharacters:Int(characters:CTCharacter[])
    Local longestLine:String = ""
    For Local character:CTCharacter = EachIn characters
        Local name:String = character.GetName()
        If name.length > longestLine.length Then longestLine = name
    Next
    Return TextWidth(longestLine)
End Function
