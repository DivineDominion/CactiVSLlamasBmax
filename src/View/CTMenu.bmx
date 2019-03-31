SuperStrict

Import "CTControl.bmx"
Import "../Util/CTMutableArray.bmx"
Import "CTMenuItem.bmx"

Global cursorImage:TImage = Null

Type CTMenu Extends CTControl
    Field selectedIndex:Int = 0
    Field menuItems:CTMutableArray = New CTMutableArray

    Function Create:CTMenu(labels:String[])
        Local menu:CTMenu = New CTMenu()

        For Local label:String = EachIn labels
            menu.AddMenuItem(label)
        Next

        Return menu
    End Function

    Method AddMenuItem:CTMenuItem(label:String)
        Local item:CTMenuItem = CTMenuItem.Create(label)
        menuItems.Append(item)
        Return item
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

    '#Region Drawing
    Public
    Method Draw(dirtyRect:CTRect)
        DrawBackground(dirtyRect)
        DrawLabels(dirtyRect)
    End Method

    Private
    Method DrawBackground(dirtyRect:CTRect)
        SetColor 0,0,0
        dirtyRect.Fill()
    End Method

    Method DrawLabels(dirtyRect:CTRect)
        Local lineHeight% = TextHeight("x")
        Local cursorWidth% = Self.GetCursorWidth()

        Local x%, y% = 0
        Local i% = 0
        For Local menuItem:CTMenuItem = EachIn menuItems
            SetColor 255, 255, 255
            DrawText menuItem.label, x + cursorWidth, y

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
