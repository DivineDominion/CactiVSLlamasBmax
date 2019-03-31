SuperStrict

Import "CTView.bmx"
Import "CTColor.bmx"
Import "CTRect.bmx"
Import "CTViewport.bmx"

Type CTWindow
    Private
    Field rect:CTRect
    Field contentViewport:CTViewport
    Global windows:CTWindow[]

    Public
    Field contentView:CTView
    Field drawContentBlock:Int()

    Function AllWindows:CTWindow[]()
        Return windows
    End Function

    Method New()
        AppendSelfToGlobalWindowList()
    End Method

    ' Width and height (w,h) include the borders, so the content rect is 2px smaller in each direction.
    Function Create:CTWindow(x%, y%, w%, h%, contentView:CTView = Null)
        Local win:CTWindow = New CTWindow
        win.rect = CTRect.Create(x, y, w, h)
        win.contentViewport = CTViewport.Create(win.rect.inset(1, 1))

        win.contentView = contentView
        If contentView = Null Then
            win.contentView = New CTView()
        EndIf

        Return win
    End Function

    Method ReplaceContentView(newContentView:CTView)
        Assert newContentView Else "CTWindow.ReplaceContentView requires newContentView"
        Self.contentView = newContentView
    End Method

    Method Draw()
        ' Shadow
        SetColor 0, 0, 0
        rect.Translate(1, 1).Draw()

        ' Frame
        SetColor 255, 255, 255
        rect.Draw()

        ' Content
        contentViewport.Draw(contentView)
    End Method

    Function DrawAllWindows()
        For Local win:CTWindow = EachIn windows
            win.Draw()
        Next
    End Function

    Method GetMaxY:Int()
        Return rect.GetMaxY()
    End Method

    Private
    Method AppendSelfToGlobalWindowList()
        ' Resize array
        Local oldWins:CTWindow[] = CTWindow.windows
        Local newWins:CTWindow[] = New CTWindow[oldWins.length + 1]
        For Local i:Int = 0 Until oldWins.length
            newWins[i] = oldWins[i]
        Next
        ' Append new element
        newWins[newWins.length - 1] = Self
        CTWindow.windows = newWins
    End Method
End Type
