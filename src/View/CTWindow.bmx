SuperStrict

Import "CTAnimatable.bmx"
Import "CTView.bmx"
Import "CTController.bmx"
Import "CTRect.bmx"
Import "CTViewport.bmx"
Import "CTResponder.bmx"
Import "CTLabel.bmx"
Import "CTScreen.bmx"

Type CTWindow Implements CTAnimatable
    Private
    Const BORDER_WIDTH:Int = 2
    Field rect:CTRect

    Field contentViewController:CTController
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

    Function FrameRectFittingContentRect:CTRect(contentRect:CTRect)
        Return contentRect.Outset(BORDER_WIDTH, BORDER_WIDTH)
    End Function


    Rem
    bbdoc: Width and height (`w`, `h`) include the borders, so the content rect
    is 2px smaller in each dimension.
    EndRem
    Function Create:CTWindow(x%, y%, w%, h%, contentView:CTView = Null, title:String = Null)
        Return Self.Create(New CTRect(x, y, w, h), contentView, title)
    End Function

    Function Create:CTWindow(frameRect:CTRect, controller:CTController, title:String = Null)
        Local window:CTWindow = Self.Create(frameRect, controller.View(), title)
        window.contentViewController = controller
        Return window
    End Function

    Function Create:CTWindow(frameRect:CTRect, contentView:CTView = Null, title:String = Null)
        Local win:CTWindow = New CTWindow

        If title Then win.titleLabel = New CTLabel(title, True)

        win.contentView = contentView
        If contentView = Null Then win.contentView = New CTView()

        win.rect = frameRect
        win.UpdateContentViewports()

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
        If Self.contentViewController Then Self.contentViewController.TearDown()
    End Method

    Method FrameRect:CTRect()
        Return Self.rect.Copy()
    End Method

    Method Center(arithmeticCenter:Int = False)
        Self.rect = Self.rect.CenteringInContainer(CTScreen.Main.GetBounds(), arithmeticCenter)
        UpdateContentViewports()
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


    Private
    Method UpdateContentViewports()
        Local contentFrameRect:CTRect = Self.rect.Inset(BORDER_WIDTH, BORDER_WIDTH)
        If Self.titleLabel
            Local titleHeight:Int = TextHeight(Self.titleLabel.GetTextHeight())
            Local titleRect:CTRect = contentFrameRect.SettingHeight(titleHeight)
            Self.titleViewport = CTViewport.Create(titleRect)
            contentFrameRect = contentFrameRect.Translating(0, titleHeight).Resizing(0, -titleHeight)
        End If
        Self.contentViewport = CTViewport.Create(contentFrameRect)
    End Method
End Type
