SuperStrict

Import "../View/CTRect.bmx"
Import "CTToken.bmx"
Import "CTTokenPosition.bmx"

CONST BATTLEFIELD_COLUMNS% = 3
CONST BATTLEFIELD_ROWS% = 3

Type CTBattlefield
    Private
    Field _tokenPositionsTokens:TMap = New TMap

    Public
    Method TokenPositionsTokens:TMap()
        Return _tokenPositionsTokens.Copy()
    End Method

    Method PutTokenAtColumnRow(token:CTToken, column:Int, row:Int)
        PutTokenAtPosition(token, New CTTokenPosition(column, row))
    End Method

    Method PutTokenAtPosition(token:CTToken, tokenPosition:CTTokenPosition)
        Assert token Else "PutTokenAtPosition requires token"
        Assert tokenPosition Else "PutTokenAtPosition requires tokenPosition"
        _tokenPositionsTokens.Insert(tokenPosition, token)
    End Method

    Method TokenAtPosition:CTToken(tokenPosition:CTTokenPosition)
        For Local node:TKeyValue = EachIn Self._tokenPositionsTokens
            Local currentPosition:CTTokenPosition = CTTokenPosition(node.Key())
            If currentPosition.IsEqual(tokenPosition) Then Return CTToken(node.Value())
        Next
        Return Null
    End Method
End Type
