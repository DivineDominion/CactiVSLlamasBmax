SuperStrict

Import "CTControl.bmx"
Import "../Util/CTMutableArray.bmx"
Import "CTMenuItem.bmx"
Import "DrawContrastText.bmx"

Interface CTMenuDelegate
    Method MenuDidSelectMenuItem(menu:CTMenu, menuItem:CTMenuItem)
End Interface

Type CTMenu Extends CTControl
    Private
    Field selectedIndex:Int = 0
    Field menuItems:CTMutableArray = New CTMutableArray


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

    Function Create:CTMenu(labels:String[])
        Local menu:CTMenu = New CTMenu()

        For Local label:String = EachIn labels
            menu.AddMenuItemWithLabel(label)
        Next

        Return menu
    End Function

    Method IsEmpty:Int()
        Return Self.menuItems.IsEmpty()
    End Method

    Method ResetSelection()
        Self.selectedIndex = 0
    End Method

    Method RemoveDelegate()
        Self.delegate = Null
    End Method

    Method AddMenuItemWithLabel:CTMenuItem(label:String)
        Local menuItem:CTMenuItem = CTMenuItem.Create(label)
        AddMenuItem(menuItem)
        Return menuItem
    End Method

    Method AddMenuItem(menuItem:CTMenuITem)
        menuItems.Append(menuItem)
    End Method

    Method GetSelectedMenuItem:CTMenuItem()
        Assert Not IsEmpty() Else "Cannot GetSelectedMenuItem in empty menu"
        Return CTMenuItem(menuItems.GetElementAt(selectedIndex))
    End Method


    '#Region CTKeyInterpreter
    Method MoveUp()
        If IsEmpty() Then Return

        selectedIndex :- 1
        If selectedIndex < 0
            selectedIndex = max(0, menuItems.Count() - 1)
        End If
        ' Skip Separators
        If GetSelectedMenuItem().IsSkippable()
            MoveUp()
        End If
    End Method

    Method MoveDown()
        If IsEmpty() Then Return

        selectedIndex :+ 1
        If selectedIndex >= menuItems.Count()
            selectedIndex = 0
        End If
        ' Skip Separators
        If GetSelectedMenuItem().IsSkippable()
            MoveDown()
        End If
    End Method

    Method ConfirmSelection()
        If IsEmpty() Then Return
        If Not Self.delegate Then Return
        ' FIXME: Cannot call delegate with `Self.` prefix, see: <https://github.com/bmx-ng/bcc/issues/428>
        delegate.MenuDidSelectMenuItem(Self, GetSelectedMenuItem())
    End Method
    '#End Region

    '#Region CTDrawable
    Public
    Method Draw(dirtyRect:CTRect)
        Super.Draw(dirtyRect)
        DrawLabels(dirtyRect)
    End Method

    Private
    Method DrawLabels(dirtyRect:CTRect)
        Local lineHeight% = TextHeight("x")
        Local cursorWidth% = Self.GetCursorWidth()

        Local x%, y% = 0
        If IsEmpty()
            DrawContrastText "(Empty)", x + cursorWidth, y, Self.textColor
            Return
        End If

        Local i% = 0
        For Local menuItem:CTMenuItem = EachIn menuItems
            ' Draw label text with varying font color depending on selection
            Local textColor:CTColor
            If Self.selectedIndex = i
                textColor = Self.selectedTextColor
            Else
                textColor = Self.textColor
            End If

            DrawContrastText menuItem.label, x + cursorWidth, y, textColor

            ' Draw cursor on top
            If Self.selectedIndex = i
                DrawCursor(x, y)
            End If


            y :+ lineHeight
            i :+ 1
        Next
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
