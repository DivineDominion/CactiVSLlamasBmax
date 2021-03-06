SuperStrict

Import "CTControl.bmx"
Import "CTMenuItem.bmx"
Import "DrawContrastText.bmx"

Interface CTMenuDelegate
    Method MenuDidSelectMenuItem(menu:CTMenu, menuItem:CTMenuItem)
    Method MenuDidCancel(menu:CTMenu)
    Method MenuShouldWrapAround:Int(menu:CTMenu, forwardDirection:Int)
End Interface

Interface CTMenuDrawingBase
    Method DrawCursor(x%, y%)
    Method DrawCheckmark(x%, y%)
    Method GetLineLabelOffset%()
    Method GetCursorWidth%()
    Method GetCheckmarkWidth%()
    Method IsActive%()
End Interface

Interface CTMenuItemDrawingStrategy
    Method DrawMenuItemLabels(menuItems:TList, selectedItemLink:TLink, rect:CTRect, drawingBase:CTMenuDrawingBase)
End Interface

Type CTMenu Extends CTControl Implements CTMenuDrawingBase
    Private
    Field selectedLink:TLink = Null
    Field menuItems:TList = New TList
    Field drawingStrategy:CTMenuItemDrawingStrategy
    Field isHorizontal:Int = False

    Method New(); End Method

    Public
    Global cursorImage:TImage = Null
    Global checkmarkImage:TImage = Null

    Rem
    If menu items should be displayed as selectable with a checkmark.
    End Rem
    Field displaysCheckmarks:Int = False

    Rem
    Warning: setting this to the owner of the menu creates a retain cycle.
    Make sure to call `RemoveDelegate()` in `MenuDidSelectMenuItem(menu,menuItem)`
    so the menu can close.
    End Rem
    Field delegate:CTMenuDelegate = Null

    Method New(labels:String[], isHorizontal:Int = False)
        Self.backgroundColor = CTColor.Black()
        Self.isOpaque = True

        Self.isHorizontal = isHorizontal
        If isHorizontal
            Self.drawingStrategy = New CTMenuHorizontalDrawingStrategy()
        Else
            Self.drawingStrategy = New CTMenuVerticalDrawingStrategy()
        End If

        For Local label:String = EachIn labels
            Self.AddMenuItemWithLabel(label)
        Next
    End Method

    Method TearDown()
        RemoveDelegate()
        Super.TearDown()
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

    Method SetIsEnabledForIndex(isEnabled:Int, index:Int)
        Local link:TLink = ListLinkAtIndex(Self.menuItems, index)

        If Not link Throw New TNoSuchElementException

        Local menuItem:CTMenuItem = CTMenuItem(link.Value())
        menuItem.isEnabled = isEnabled
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
        SelectFirst()
    End Method

    Method SelectFirst()
        Local link:TLink = Self.menuItems.FirstLink()
        While link And CTMenuItem(link.Value()).IsSkippable()
            link = link.NextLink()
        Wend
        Self.selectedLink = link
    End Method

    Method SelectLast()
        Local link:TLink = Self.menuItems.LastLink()
        While link And CTMenuItem(link.Value()).IsSkippable()
            link = link.PrevLink()
        Wend
        Self.selectedLink = link
    End Method

    Method SelectFirstUncheckedMenuItem()
        Local link:TLink = Self.menuItems.FirstLink()
        While link And (CTMenuItem(link.Value()).IsSkippable() Or CTMenuItem(link.Value()).isChecked)
            link = link.NextLink()
        Wend
        Self.selectedLink = link
        If Self.selectedLink = Null Then Self.selectedLink = Self.menuItems.FirstLink()
    End Method
    '#End Region


    '#Region CTKeyInterpreter
    Method MoveUp()
        If isHorizontal Then Return
        SelectPrevious()
    End Method

    Method MoveLeft()
        If Not isHorizontal Then Return
        SelectPrevious()
    End Method

    Method MoveDown()
        If isHorizontal Then Return
        SelectNext()
    End Method

    Method MoveRight()
        If Not isHorizontal Then Return
        SelectNext()
    End Method

    Method ConfirmSelection()
        If Not selectedLink Then Return
        If Not Self.delegate Then Return
        ' FIXME: Cannot call delegate with `Self.` prefix, see: <https://github.com/bmx-ng/bcc/issues/428>
        delegate.MenuDidSelectMenuItem(Self, GetSelectedMenuItem())
    End Method

    Method Cancel()
        ' FIXME: Cannot call delegate with `Self.` prefix, see: <https://github.com/bmx-ng/bcc/issues/428>
        If Self.delegate Then delegate.MenuDidCancel(Self)
    End Method


    Private
    Method SelectPrevious()
        If IsEmpty() Then Return

        selectedLink = LinkBeforeSelection()

        ' Skip Separators and disabled items
        If GetSelectedMenuItem().IsSkippable()
            SelectPrevious()
        End If
    End Method

    Method SelectNext()
        If IsEmpty() Then Return

        selectedLink = LinkAfterSelection()

        ' Skip Separators and disabled items
        If GetSelectedMenuItem().IsSkippable()
            SelectNext()
        End If
    End Method

    Method LinkAfterSelection:TLink()
        ' Wrap around or stop at end
        Local nextLink:TLink = selectedLink.NextLink()
        If nextLink Then Return nextLink
        If ShouldWrapAround(True) Then Return menuItems.FirstLink()
        Return selectedLink
    End Method

    Method LinkBeforeSelection:TLink()
        ' Wrap around or stop at start
        Local prevLink:TLink = selectedLink.PrevLink()
        If prevLink Then Return prevLink
        If ShouldWrapAround(False) Then Return menuItems.LastLink()
        Return selectedLink
    End Method

    Method ShouldWrapAround:Int(forwardDirection:Int)
        IF Not Self.delegate Return True
        ' FIXME: Cannot call delegate with `Self.` prefix, see: <https://github.com/bmx-ng/bcc/issues/428>
        Return delegate.MenuShouldWrapAround(Self, forwardDirection)
    End Method
    '#End Region


    '#Region CTDrawable
    Public
    Method DrawInterior(dirtyRect:CTRect)
        Super.DrawInterior(dirtyRect)

        If IsEmpty()
            DrawEmptinessIndicator(dirtyRect)
        Else
            DrawMenuItemLabels(dirtyRect)
        EndIf
    End Method


    Private
    Method DrawEmptinessIndicator(dirtyRect:CTRect)
        DrawContrastText "(Empty)", 0, 0, CTColor.DefaultMenuItemColor()
    End Method

    Method DrawMenuItemLabels(dirtyRect:CTRect)
        Self.drawingStrategy.DrawMenuItemLabels(Self.menuItems, selectedLink, dirtyRect, Self)
    End Method
    '#End Region

    '#Region CTMenuDrawingBase
    Public
    Method DrawCursor(x%, y%)
        If Not CTMenu.cursorImage Then Return

        Local oldBlend% = GetBlend()
        Local oldAlpha# = GetAlpha()
        SetBlend(ALPHABLEND)

        If IsActive()
            SetAlpha(1.0)
        Else
            SetAlpha(0.5)
        End If

        DrawImage CTMenu.cursorImage, x, y

        SetAlpha(oldAlpha)
        SetBlend(oldBlend)
    End Method

    Method DrawCheckmark(x%, y%)
        If Not CTMenu.checkmarkImage Then Return

        Local oldAlpha# = GetAlpha()
        If IsActive()
            SetAlpha 1.0
        Else
            SetAlpha 0.5
        End If

        DrawImage CTMenu.checkmarkImage, x, y

        SetAlpha oldAlpha
    End Method

    Method GetLineLabelOffset%()
        Return GetCursorWidth() + GetCheckmarkWidth()
    End Method

    Method GetCursorWidth%()
        If Not CTMenu.cursorImage Then Return 0
        Return ImageWidth(CTMenu.cursorImage)
    End Method

    Method GetCheckmarkWidth%()
        If Not Self.displaysCheckmarks Then Return 0
        If Not CTMenu.checkmarkImage Then Return 0
        Return ImageWidth(CTMenu.checkmarkImage)
    End Method

    Method IsActive%()
        Return IsFirstResponder(Self)
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

Type CTMenuVerticalDrawingStrategy Implements CTMenuItemDrawingStrategy
    Method DrawMenuItemLabels(menuItems:TList, selectedItemLink:TLink, rect:CTRect, base:CTMenuDrawingBase)
        Local lineHeight% = TextHeight("x")
        Local labelOffset% = base.GetLineLabelOffset()
        Local checkmarkOffset% = base.GetCursorWidth()

        Local x%, y% = 0
        Local link:TLink = menuItems.FirstLink()
        While link
            Local menuItem:CTMenuItem = CTMenuItem(link.Value())
            Local isSelected:Int = (selectedItemLink And selectedItemLink = link) And base.IsActive()
            Local textColor:CTColor = TextColor(menuItem.isEnabled, isSelected)

            DrawContrastText menuItem.label, x + labelOffset, y, textColor

            ' Draw cursor on top (doesn't appear in first line if drawn first)
            If isSelected Then base.DrawCursor(x, y)
            If menuItem.isChecked Then base.DrawCheckmark(x + checkmarkOffset, y)

            y :+ lineHeight
            link = link.NextLink()
        Wend
    End Method
End Type

Type CTMenuHorizontalDrawingStrategy Implements CTMenuItemDrawingStrategy
    Const COLUMNS:Int = 2 ' Small screen, support 2 columns for now

    Method DrawMenuItemLabels(menuItems:TList, selectedItemLink:TLink, rect:CTRect, base:CTMenuDrawingBase)
        Local lineHeight% = TextHeight("x")
        Local labelOffset% = base.GetLineLabelOffset()
        Local checkmarkOffset% = base.GetCursorWidth()

        Local columnWidth% = rect.GetWidth() / COLUMNS
        Local i% = 0
        Local link:TLink = menuItems.FirstLink()
        While link
            Local menuItem:CTMenuItem = CTMenuItem(link.Value())
            Local isSelected:Int = (selectedItemLink And selectedItemLink = link) And base.IsActive()
            Local textColor:CTColor = TextColor(menuItem.isEnabled, isSelected)

            Local x% = (i Mod COLUMNS) * columnWidth
            Local y% = (i / COLUMNS) * lineHeight
            DrawContrastText menuItem.label, x + labelOffset, y, textColor

            ' Draw cursor on top (doesn't appear in first line if drawn first)
            If isSelected Then base.DrawCursor(x, y)
            If menuItem.isChecked Then base.DrawCheckmark(x + checkmarkOffset, y)

            i :+ 1
            link = link.NextLink()
        Wend
    End Method
End Type

Function TextColor:CTColor(isEnabled:Int, isHighlighted:Int)
    If Not isEnabled Then Return CTColor.DisabledMenuItemColor()
    If isHighlighted Then Return CTColor.SelectedMenuItemColor()
    Return CTColor.DefaultMenuItemColor()
End Function
