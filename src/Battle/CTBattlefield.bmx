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

    Method TokenAtPosition:CTToken(tokenPosition:CTTokenPosition)
        For Local node:TKeyValue = EachIn Self.tokenPositionsTokens
            Local currentPosition:CTTokenPosition = CTTokenPosition(node.Key())
            If currentPosition.IsEqual(tokenPosition) Then Return CTToken(node.Value())
        Next
        Return Null
    End Method

    Method RectForPosition:CTRect(position:CTTokenPosition)
        Return RectForColumnRow(position.column, position.row)
    End Method

    Method RectForColumnRow:CTRect(column:Int, row:Int)
        Local x:Int = column * 50
        Local y:Int = row * 50
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
