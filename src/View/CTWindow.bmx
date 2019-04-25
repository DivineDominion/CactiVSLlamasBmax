SuperStrict

Import "CTAnimatable.bmx"
Import "CTView.bmx"
Import "CTController.bmx"
Import "CTRect.bmx"
Import "CTViewport.bmx"
Import "CTResponder.bmx"
Import "CTLabel.bmx"

Type CTWindow Implements CTAnimatable
    Private
    Const BORDER_WIDTH:Int = 2
    Field rect:CTRect

    Field contentViewport:CTViewport
    Field contentView:CTView

    Field titleViewport:CTViewport
    Field titleLabel:CTLabel

    Public
    Function FrameRectFittingLinesAndTitle:CTRect(x%, y%, w%, textLines%)
        Return FrameRectFittingLines(x, y, w, textLines + 1)
    End Function

    Function FrameRectFittingLines:CTRect(x%, y%, w%, textLines%)
        Local contentHeight% = textLines * TextHeight("x")
        Return New CTRect(x, y, w, contentHeight + (BORDER_WIDTH * 2))
    End Function

    Rem
    bbdoc: Width and height (`w`, `h`) include the borders, so the content rect
    is 2px smaller in each dimension.
    EndRem
    Function Create:CTWindow(x%, y%, w%, h%, contentView:CTView = Null, title:String = Null)
        Return Self.Create(New CTRect(x, y, w, h), contentView, title)
    End Function

    Function Create:CTWindow(frameRect:CTRect, controller:CTController, title:String = Null)
        Return Self.Create(frameRect, controller.View(), title)
    End Function

    Function Create:CTWindow(frameRect:CTRect, contentView:CTView = Null, title:String = Null)
        Local win:CTWindow = New CTWindow
        win.rect = frameRect

        Local contentFrameRect:CTRect = frameRect.inset(BORDER_WIDTH, BORDER_WIDTH)
        If title
            Local titleHeight:Int = TextHeight(title)
            Local titleRect:CTRect = contentFrameRect.SettingHeight(titleHeight)
            win.titleViewport = CTViewport.Create(titleRect)
            win.titleLabel = CTLabel.Create(title, True)
            contentFrameRect = contentFrameRect.Translating(0, titleHeight).Resizing(0, -titleHeight)
        End If
        win.contentViewport = CTViewport.Create(contentFrameRect)

        win.contentView = contentView
        If contentView = Null Then
            win.contentView = New CTView()
        EndIf

        Return win
    End Function

    Method GetContentView:CTView()
        Return Self.contentView
    End Method

    Method ReplaceContentView(newContentView:CTView)
        Assert newContentView Else "CTWindow.ReplaceContentView requires newContentView"
        ReplaceResponderWithNewResponder(CTResponder(Self.contentView), CTResponder(newContentView))
        Self.contentView = newContentView
    End Method

    Method MakeKey()
        Local responder:CTResponder = CTResponder(Self.contentView)
        If responder Then responder.MakeFirstResponder()
    End Method

    Method IsKey:Int()
        Local responder:CTResponder = CTResponder(Self.contentView)
        If responder = Null Then Return False
        Return IsFirstResponder(responder)
    End Method

    Method TearDown()
        If Self.contentView Then Self.contentView.TearDown()
    End Method

    Method FrameRect:CTRect()
        Return Self.rect.Copy()
    End Method

    Method GetMaxY:Int()
        Return rect.GetMaxY()
    End Method

    Method Draw()
        ' Shadow
        SetColor 0, 0, 0
        rect.Translating(1, 1).Fill()

        ' Frame
        CTColor.WindowFrameColor().Set()
        rect.Fill()

        ' Title
        If titleViewport And titleLabel
            titleViewport.Draw(titleLabel)
        End If

        ' Content
        contentViewport.Draw(contentView)
    End Method

    '#Region CTAnimatable
    Method UpdateAnimation(delta:Float)
        Self.contentView.UpdateAnimation(delta)
    End Method
    '#End Region
End Type
