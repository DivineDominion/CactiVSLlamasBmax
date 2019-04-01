SuperStrict

Import "CTControl.bmx"
Import "../Util/CTMutableArray.bmx"
Import "CTMenuItem.bmx"
Import "DrawContrastText.bmx"

Global cursorImage:TImage = Null

Interface CTMenuDelegate
    Method MenuDidSelectMenuItem(menu:CTMenu, menuItem:CTMenuItem)
End Interface

Type CTMenu Extends CTControl
    Private
    Field selectedIndex:Int = 0
    Field menuItems:CTMutableArray = New CTMutableArray


    Public
    Field backgroundColor:CTColor = CTColor.Black()
    Field textColor:CTColor = CTColor.LightGray()
    Field selectedTextColor:CTColor = CTColor.White()

    Rem
    Warning: setting this to the owner of the menu creates a retain cycle.
    Make sure to call `RemoveDelegate()` in `MenuDidSelectMenuItem(menu,menuItem)`
    so the menu can close.
    End Rem
    Field delegate:CTMenuDelegate = Null

    Function Create:CTMenu(labels:String[])
        Local menu:CTMenu = New CTMenu()

        For Local label:String = EachIn labels
            menu.AddMenuItem(label)
        Next

        Return menu
    End Function

    Method RemoveDelegate()
        Self.delegate = Null
    End Method

    Method AddMenuItem:CTMenuItem(label:String)
        Local item:CTMenuItem = CTMenuItem.Create(label)
        menuItems.Append(item)
        Return item
    End Method

    Method GetSelectedMenuItem:CTMenuItem()
        Return CTMenuItem(menuItems.GetElementAt(selectedIndex))
    End Method

    Method MoveUp()
        selectedIndex :- 1
        If selectedIndex < 0
            selectedIndex = max(0, menuItems.Count() - 1)
        End If
    End Method

    Method MoveDown()
        selectedIndex :+ 1
        If selectedIndex >= menuItems.Count()
            selectedIndex = 0
        End If
    End Method

    Method ConfirmSelection()
        If Self.delegate
            Self.delegate.menuDidSelectMenuItem(Self, GetSelectedMenuItem())
        End If
    End Method

    '#Region Drawing
    Public
    Method Draw(dirtyRect:CTRect)
        DrawBackground(dirtyRect)
        DrawLabels(dirtyRect)
    End Method

    Private
    Method DrawBackground(dirtyRect:CTRect)
        Self.backgroundColor.Set()
        dirtyRect.Fill()
    End Method

    Method DrawLabels(dirtyRect:CTRect)
        Local lineHeight% = TextHeight("x")
        Local cursorWidth% = Self.GetCursorWidth()

        Local x%, y% = 0
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
        If Not cursorImage
            Return
        End If
        DrawImage cursorImage, x, y
    End Method

    Method GetCursorWidth%()
        If cursorImage
            Return ImageWidth(cursorImage)
        End If
        Return 0
    End Method
    '#End Region
End Type
