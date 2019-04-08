SuperStrict

Import "CTView.bmx"
Import "DrawContrastText.bmx"

Type CTLabel Extends CTView
    Field text:String = ""
    Field textColor:CTColor = CTColor.Yellow()
    Field isCentered:Int

    Method New()
        Self.isOpaque = True
        Self.backgroundColor = CTColor.Black()
        Self.isCentered = False
    End Method

    Function Create:CTLabel(text:String, isCentered:Int = False)
        Local label:CTLabel = New CTLabel
        label.text = text
        label.isCentered = isCentered
        Return label
    End Function

    Method HasText:Int()
        Return Self.text And Self.text.length > 0
    End Method

    Method Draw(dirtyRect:CTRect)
        Super.Draw(dirtyRect)

        If Not HasText() Then Return

        Local x% = 0
        If isCentered
            x = (dirtyRect.GetWidth() - TextWidth(Self.text)) / 2
        End If

        DrawContrastText Self.text, x, 0, Self.textColor
    End Method
End Type
