SuperStrict

Import "CTControl.bmx"
Import "CTMenuItem.bmx"
Import "DrawContrastText.bmx"

Interface CTMenuDelegate
    Method MenuDidSelectMenuItem(menu:CTMenu, menuItem:CTMenuItem)
End Interface

Type CTMenu Extends CTControl
    Private
    Field selectedLink:TLink = Null
    Field menuItems:TList = New TList


    Public
    Global cursorImage:TImage = Null
    Field textColor:CTColor = CTColor.LightGray()
    Field selectedTextColor:CTColor = CTColor.White()

    Rem
    Warning: setting this to the owner of the menu creates a retain cycle.
    Make sure to call `RemoveDelegate()` in `MenuDidSelectMenuItem(menu,menuItem)`
    so the menu can close.
    End Rem
    Field delegate:CTMenuDelegate = Null

    Method New()
        Self.backgroundColor = CTColor.Black()
        Self.isOpaque = True
    End Method

    Method New(labels:String[])
        New()
        For Local label:String = EachIn labels
            Self.AddMenuItemWithLabel(label)
        Next
    End Method

    Method RemoveDelegate()
        Self.delegate = Null
    End Method


    '#Region Menu Contents
    Public
    Method AddMenuItemWithLabel:CTMenuItem(label:String)
        Local menuItem:CTMenuItem = New CTMenuItem(label)
        AddMenuItem(menuItem)
        Return menuItem
    End Method

    Method AddMenuItem(menuItem:CTMenuItem)
        ListAddLast(Self.menuItems, menuItem)
        SetInitialSelectionIfNecessary()
    End Method

    Method InsertMenuItemAtIndex(menuItem:CTMenuItem, index:Int)
        ListInsertBeforeIndex(Self.menuItems, menuItem, index)
        SetInitialSelectionIfNecessary()
    End Method

    Method RemoveMenuItem(menuItem:CTMenuItem)
        Local link:TLink = ListFindLink(Self.menuItems, menuItem)

        If Not link Throw New TNoSuchElementException

        ' Move selection down (or up if at end of list) when selection is removed
        If link = selectedLink
            If link.NextLink()
                selectedLink = link.NextLink()
            Else
                selectedLink = link.PrevLink()
            End If
        End If

        link.Remove()
    End Method

    Method IsEmpty:Int()
        Return Self.menuItems.IsEmpty()
    End Method

    Method Count:Int()
        Return Self.menuItems.Count()
    End Method


    Private
    Method SetInitialSelectionIfNecessary()
        ' Fixup when adding items to empty lists: select the first item
        If Not selectedLink Then ResetSelection()
    End Method
    '#End Region


    '#Region Selection
    Public
    Method GetSelectedMenuItem:CTMenuItem()
        Assert selectedLink Else "Cannot GetSelectedMenuItem without selection"
        Return CTMenuItem(selectedLink.Value())
    End Method

    Method ResetSelection()
        Self.selectedLink = Self.menuItems.FirstLink()
    End Method
    '#End Region


    '#Region CTKeyInterpreter
    Method MoveUp()
        If IsEmpty() Then Return

        selectedLink = selectedLink.PrevLink()
        If Not selectedLink
            selectedLink = menuItems.LastLink()
        End If
        ' Skip Separators
        If GetSelectedMenuItem().IsSkippable()
            MoveUp()
        End If
    End Method

    Method MoveDown()
        If IsEmpty() Then Return

        selectedLink = selectedLink.NextLink()
        If Not selectedLink
            selectedLink = menuItems.FirstLink()
        End If
        ' Skip Separators
        If GetSelectedMenuItem().IsSkippable()
            MoveDown()
        End If
    End Method

    Method ConfirmSelection()
        If Not selectedLink Then Return
        If Not Self.delegate Then Return
        ' FIXME: Cannot call delegate with `Self.` prefix, see: <https://github.com/bmx-ng/bcc/issues/428>
        delegate.MenuDidSelectMenuItem(Self, GetSelectedMenuItem())
    End Method
    '#End Region


    '#Region CTDrawable
    Public
    Method Draw(dirtyRect:CTRect)
        Super.Draw(dirtyRect)

        If IsEmpty()
            DrawEmptinessIndicator(dirtyRect)
        Else
            DrawMenuItemLabels(dirtyRect)
        EndIF
    End Method


    Private
    Method DrawEmptinessIndicator(dirtyRect:CTRect)
        Local textColor:CTColor = Self.textColor
        If IsFirstResponder(Self) Then textColor = Self.selectedTextColor
        DrawContrastText "(Empty)", 0, 0, textColor
    End Method

    Method DrawMenuItemLabels(dirtyRect:CTRect)
        Local lineHeight% = TextHeight("x")
        Local cursorWidth% = Self.GetCursorWidth()

        Local x%, y% = 0
        Local i% = 0
        Local link:TLink = menuItems.FirstLink()
        While link
            Local menuItem:CTMenuItem = CTMenuItem(link.Value())
            Local isSelected:Int = False
            If Self.selectedLink And Self.selectedLink = link And IsFirstResponder(Self) Then isSelected = True

            ' Draw label text with varying font color depending on selection
            Local textColor:CTColor = Self.textColor
            If isSelected Then textColor = Self.selectedTextColor

            DrawContrastText menuItem.label, x + cursorWidth, y, textColor

            ' Draw cursor on top (doesn't appear if drawn first)
            If isSelected Then DrawCursor(x, y)

            y :+ lineHeight
            i :+ 1
            link = link.NextLink()
        Wend
    End Method

    Method DrawCursor(x%, y%)
        If Not CTMenu.cursorImage Then Return

        Local oldAlpha# = GetAlpha()
        If IsFirstResponder(Self)
            SetAlpha 1.0
        Else
            SetAlpha 0.5
        End If

        DrawImage CTMenu.cursorImage, x, y

        SetAlpha oldAlpha
    End Method

    Method GetCursorWidth%()
        If CTMenu.cursorImage
            Return ImageWidth(CTMenu.cursorImage)
        End If
        Return 0
    End Method
    '#End Region
End Type

Private
Function ListInsertBeforeIndex(list:TList, item:Object, index:Int)
    If list.IsEmpty()
        If index <> 0 Then Throw New TIndexOutOfBoundsException
        list.AddFirst(item)
    ElseIf index = 0
        list.AddFirst(item)
    ElseIf index = list.Count()
        list.AddLast(item)
    Else
        Local link:TLink = ListLinkAtIndex(list, index)
        If Not link Then Throw New TNoSuchElementException
        list.InsertBeforeLink(item, link)
    EndIf
End Function

Function ListLinkAtIndex:TLink(list:TList, index:Int)
    Assert index >= 0 Else "Object index must be positive"
    Local link:TLink = list.FirstLink()
    While link
        If Not index Return link
        link = link.NextLink()
        index :- 1
    Wend
    RuntimeError "List index out of range"
End Function
