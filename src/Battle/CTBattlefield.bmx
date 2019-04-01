SuperStrict

Import "../View/CTRect.bmx"
Import "../Util/CTMutableArray.bmx"
Import "CTTokenPosition.bmx"

Type CTToken Abstract
    Field position:CTTokenPosition

    ' FIXME: You need to duplicate the constructor in the concrete type, see: https://github.com/bmx-ng/bcc/issues/417
    Method New(position:CTTokenPosition)
        Self.position = position
    End Method

    Method Draw(battleField:CTBattlefield) Abstract
End Type

Type CTBattlefield
    Private
    Field tokens:CTMutableArray = New CTMutableArray

    Public
    Method AddToken(token:CTToken)
        Assert token Else "AddToken requires token"
        tokens.Append(token)
    End Method

    Method RectForPosition:CTRect(position:CTTokenPosition)
        Local x:Int = position.column * 50
        Local y:Int = position.row * 50
        Return CTRect.Create(x, y, 50, 50)
    End Method

    Method DrawTokens()
        For Local token:CTToken = EachIn Self.tokens
            token.Draw(Self)
        Next
    End Method
End Type
