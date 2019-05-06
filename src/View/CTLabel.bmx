SuperStrict

Import "CTView.bmx"
Import "DrawContrastText.bmx"

Type CTLabel Extends CTView
    Private
    Method New(); End Method

    Public
    Field text:String = ""
    Field textColor:CTColor = CTColor.DefaultTextColor()
    Field isCentered:Int

    Method New(text:String, isCentered:Int = False)
        Self.text = text
        Self.isOpaque = True
        Self.backgroundColor = CTColor.Black()
        Self.isCentered = isCentered
    End Method

    Method GetTextHeight:Int()
        If Not HasText() Then Return 0
        Return TextHeight(Self.text)
    End Method

    Method HasText:Int()
        Return Self.text And Self.text.length > 0
    End Method

    Method DrawInterior(dirtyRect:CTRect)
        Super.DrawInterior(dirtyRect)

        If Not HasText() Then Return

        Local x% = 0
        If isCentered
            x = (dirtyRect.GetWidth() - TextWidth(Self.text)) / 2
        End If

        DrawContrastText Self.text, x, 0, Self.textColor
    End Method
End Type
