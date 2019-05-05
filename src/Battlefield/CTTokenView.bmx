SuperStrict

Import "../View/CTView.bmx"
Import "CTTokenPosition.bmx"
Import "CTToken.bmx"
Import "CTCactusToken.bmx"

Type CTTokenView Extends CTView
    Private
    Field bgColor:CTColor
    Field nameColor:CTColor

    Method New(); End Method

    Public
    Field ReadOnly token:CTToken

    Function CreateTokenView:CTTokenView(token:CTToken)
        Local cactusToken:CTCactusToken = CTCactusToken(token)
        If cactusToken Then Return CreateCactusTokenView(cactusToken)
        RuntimeError "Could not determine the token type in #CreateTokenView"
    End Function

    Function CreateCactusTokenView:CTTokenView(cactusToken:CTCactusToken)
        Local bgColor:CTColor = CTColor.Create(0, 255, 0)
        Local nameColor:CTColor = CTColor.Create(0, 0, 0)
        Return New CTTokenView(cactusToken, bgColor, nameColor)
    End Function

    Method New(token:CTToken, bgColor:CTColor, nameColor:CTColor)
        Assert token Else "CTTokenView requires token"
        Assert bgColor Else "CTTokenView requires bgColor"
        Assert nameColor Else "CTTokenView requires nameColor"
        Self.token = token
        Self.bgColor = bgColor
        Self.nameColor = nameColor
    End Method


    '#Region CTDrawable
    Public
    Method DrawInterior(dirtyRect:CTRect)
        bgColor.Set()
        dirtyRect.Inset(4, 4).Fill()

        nameColor.Set()
        DrawText token.GetName(), 6, dirtyRect.GetMaxY() - 6 - TextHeight("x")
    End Method
    '#End Region
End Type
