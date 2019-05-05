SuperStrict

Import "../Event.bmx"
Import "../View/CTRect.bmx"
Import "CTToken.bmx"
Import "CTTokenPosition.bmx"
Import "CTBattlefieldChange.bmx"

Const BATTLEFIELD_COLUMNS% = 3
Const BATTLEFIELD_ROWS% = 3

Type CTBattlefield
    '#Region Battlefield contents
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

    Method PositionOfToken:CTTokenPosition(token:CTToken)
        For Local node:TKeyValue = EachIn Self._tokenPositionsTokens
            Local currentToken:CTToken = CTToken(node.Value())
            If currentToken = token Then Return CTTokenPosition(node.Key())
        Next
        Return Null
    End Method

    Method FirstTokenInCharacterList:CTToken(characters:TList)
        Local resultNode:TKeyValue = Null
        For Local node:TKeyValue = EachIn Self._tokenPositionsTokens
            Local currentToken:CTToken = CTToken(node.Value())
            If characters.Contains(currentToken.character) And currentToken.character.IsAlive()
                If resultNode <> Null
                    Local oldTokenPosition:CTTokenPosition = CTTokenPosition(resultNode.Key())
                    Local currentTokenPosition:CTTokenPosition = CTTokenPosition(node.Key())
                    If currentTokenPosition.Compare(resultNode) = -1
                        resultNode = node
                    End If
                Else
                    resultNode = node
                End If
            End If
        Next
        If Not resultNode Then Return Null
        Return CTToken(resultNode.Value())
    End Method
    '#End Region


    '#Region Changing tokens on battlefield
    Public
    Method PutTokenAtColumnRow(token:CTToken, column:Int, row:Int)
        PutTokenAtPosition(token, New CTTokenPosition(column, row))
    End Method

    Method PutTokenAtPosition(token:CTToken, tokenPosition:CTTokenPosition)
        Assert token Else "PutTokenAtPosition requires token"
        Assert tokenPosition Else "PutTokenAtPosition requires tokenPosition"
        _tokenPositionsTokens.Insert(tokenPosition, token)
        Self.FireAdditionAtPosition(token, tokenPosition)
        Self.FireChangeAtPosition(tokenPosition)
    End Method

    Method RemoveTokenAtPosition:CTToken(tokenPosition:CTTokenPosition)
        If Not Self._tokenPositionsTokens.Contains(tokenPosition) Then Return Null
        Local token:CTToken = CTToken(Self._tokenPositionsTokens.ValueForKey(tokenPosition))
        Self._tokenPositionsTokens.Remove(tokenPosition)
        Self.FireRemovalAtPosition(token, tokenPosition)
        Self.FireChangeAtPosition(tokenPosition)
        Return token
    End Method

    Private
    Method FireRemovalAtPosition(token:CTToken, tokenPosition:CTTokenPosition)
        Fire("BattlefieldDidRemoveToken", Self, New CTBattlefieldChange(token, tokenPosition))
    End Method

    Method FireAdditionAtPosition(token:CTToken, tokenPosition:CTTokenPosition)
        Fire("BattlefieldDidAddToken", Self, New CTBattlefieldChange(token, tokenPosition))
    End Method

    Method FireChangeAtPosition(tokenPosition:CTTokenPosition)
        Fire("BattlefieldDidChange", Self, tokenPosition)
    End Method
    '#End Region


    '#Region Event Forwarding
    Public
    Method OnCharacterDidDie(character:CTCharacter)
        Local tokenPosition:CTTokenPosition = PositionOfTokenForCharacter(character)
        If Not tokenPosition Then Return
        RemoveTokenAtPosition(tokenPosition)
    End Method
    '#End Region
End Type
