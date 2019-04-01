SuperStrict

Import "../View/CTRect.bmx"
Import "CTToken.bmx"
Import "CTTokenPosition.bmx"

Type CTBattlefield
    Private
    Field tokenPositionsTokens:TMap = New TMap

    Public
    Method PutTokenAtColumnRow(token:CTToken, column:Int, row:Int)
        PutTokenAtPosition(token, New CTTokenPosition(column, row))
    End Method

    Method PutTokenAtPosition(token:CTToken, tokenPosition:CTTokenPosition)
        Assert token Else "PutTokenAtPosition requires token"
        Assert tokenPosition Else "PutTokenAtPosition requires tokenPosition"
        tokenPositionsTokens.Insert(tokenPosition, token)
    End Method

    Method RectForPosition:CTRect(position:CTTokenPosition)
        Local x:Int = position.column * 50
        Local y:Int = position.row * 50
        Return CTRect.Create(x, y, 50, 50)
    End Method

    Method DrawTokens()
        For Local node:TKeyValue = EachIn Self.tokenPositionsTokens
            Local token:CTToken = CTToken(node.Value())
            Local tokenPosition:CTTokenPosition = CTTokenPosition(node.Key())
            Local tokenRect:CTRect = Self.RectForPosition(tokenPosition)
            token.DrawOnBattlefield(tokenRect)
        Next
    End Method
End Type
