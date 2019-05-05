SuperStrict

Import "CTToken.bmx"
Import "CTTokenPosition.bmx"

Rem
Event payload.
End Rem
Type CTBattlefieldChange
    Field ReadOnly token:CTToken
    Field ReadOnly tokenPosition:CTTokenPosition

    Method New(token:CTToken, tokenPosition:CTTokenPosition)
        Assert token Else "CTBattlefieldChange requires token"
        Assert tokenPosition Else "CTBattlefieldChange requires tokenPosition"
        Self.token = token
        Self.tokenPosition = tokenPosition
    End Method
End Type
