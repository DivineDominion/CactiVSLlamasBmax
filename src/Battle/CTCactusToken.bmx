SuperStrict

Import "CTToken.bmx"
Import "../View/CTColor.bmx"
Import "../View/CTRect.bmx"
Import "../Army/CTCactus.bmx"

Type CTCactusToken Extends CTToken
    Field bgColor:CTColor = CTColor.Create(0, 255, 0)
    Field nameColor:CTColor = CTColor.Create(0, 0, 0)
    Field ReadOnly cactus:CTCactus

    Method New(cactus:CTCactus)
        Self.cactus = cactus
    End Method

    Method DrawOnBattlefield(rect:CTRect)
        bgColor.Set()
        rect.Inset(4, 4).Fill()
        nameColor.Set()
        DrawText cactus.GetName(), rect.GetX() + 6, rect.GetMaxY() - 6 - TextHeight("x")
    End Method

    Method GetCharacter:CTCharacter()
        Return cactus
    End Method
End Type
