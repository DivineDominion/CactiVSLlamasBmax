SuperStrict

Import "../View/CTRect.bmx"
Import "../Battlefield/CTToken.bmx"
Import "../Battlefield/CTTokenPosition.bmx"

Const BATTLEFIELD_COLUMNS% = 3
Const BATTLEFIELD_ROWS% = 3

Type CTBattlefield
    Private
    Field _tokenPositionsTokens:TMap = New TMap

    Public
    Method TokenPositionsTokens:TMap()
        Return _tokenPositionsTokens.Copy()
    End Method

    Method AllTokens:TList()
        Local results:TList = New TList()
        For Local token:CTToken = EachIn _tokenPositionsTokens.Values()
            results.AddLast(token)
        Next
        Return results
    End Method

    Method PutTokenAtColumnRow(token:CTToken, column:Int, row:Int)
        PutTokenAtPosition(token, New CTTokenPosition(column, row))
    End Method

    Method PutTokenAtPosition(token:CTToken, tokenPosition:CTTokenPosition)
        Assert token Else "PutTokenAtPosition requires token"
        Assert tokenPosition Else "PutTokenAtPosition requires tokenPosition"
        token.SetCharacterAnimator(Self.characterAnimator)
        _tokenPositionsTokens.Insert(tokenPosition, token)
    End Method

    Method TokenAtPosition:CTToken(tokenPosition:CTTokenPosition)
        For Local node:TKeyValue = EachIn Self._tokenPositionsTokens
            Local currentPosition:CTTokenPosition = CTTokenPosition(node.Key())
            If currentPosition.IsEqual(tokenPosition) Then Return CTToken(node.Value())
        Next
        Return Null
    End Method

    Method PositionOfTokenForCharacter:CTTokenPosition(character:CTCharacter)
        For Local node:TKeyValue = EachIn Self._tokenPositionsTokens
            Local currentToken:CTToken = CTToken(node.Value())
            If currentToken.character = character Then Return CTTokenPosition(node.Key())
        Next
        Return Null
    End Method

    Method RemoveTokenAtPosition:CTToken(tokenPosition:CTTokenPosition)
        If Not Self._tokenPositionsTokens.Contains(tokenPosition) Then Return Null
        Local token:CTToken = CTToken(Self._tokenPositionsTokens.ValueForKey(tokenPosition))
        Self._tokenPositionsTokens.Remove(tokenPosition)
        token.SetCharacterAnimator(Null)
        Return token
    End Method

    '#Region Character animation
    Private
    Field characterAnimator:CTCharacterAnimator = Null

    Public
    Method SetCharacterAnimator(animator:CTCharacterAnimator)
        Self.characterAnimator = animator

        ' Update all tokens
        For Local token:CTToken = EachIn _tokenPositionsTokens.Values()
            token.SetCharacterAnimator(animator)
        Next
    End Method
    '#End Region
End Type