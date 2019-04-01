SuperStrict

Import "CTAnimatable.bmx"
Import "CTView.bmx"
Import "CTRect.bmx"
Import "CTViewport.bmx"

Type CTWindow Implements CTAnimatable
    Private
    Field rect:CTRect
    Field contentViewport:CTViewport

    Public
    Field contentView:CTView

    Rem
    bbdoc: Width and height (`w`, `h`) include the borders, so the content rect
    is 2px smaller in each dimension.
    EndRem
    Function Create:CTWindow(x%, y%, w%, h%, contentView:CTView = Null)
        Return Self.Create(New CTRect(x, y, w, h), contentView)
    End Function

    Function Create:CTWindow(frameRect:CTRect, contentView:CTView = Null)
        Local win:CTWindow = New CTWindow
        win.rect = frameRect
        win.contentViewport = CTViewport.Create(frameRect.inset(1, 1))

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

    Method GetMaxY:Int()
        Return rect.GetMaxY()
    End Method

    Method Draw()
        ' Shadow
        SetColor 0, 0, 0
        rect.Translate(1, 1).Fill()

        ' Frame
        SetColor 255, 255, 255
        rect.Fill()

        ' Content
        contentViewport.Draw(contentView)
    End Method

    '#Region CTAnimatable
    Method UpdateAnimation(delta:Float)
        Self.contentView.UpdateAnimation(delta)
    End Method
    '#End Region
End Type
