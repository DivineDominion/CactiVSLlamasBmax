SuperStrict

Type CTCharacter Abstract
    Private
    Global nextCharacterID:Int = 1
    Field characterID:Int

    Public
    Method New()
        characterID = CTCharacter.nextCharacterID
        CTCharacter.nextCharacterID :+ 1
    End Method

    Method GetID:Int()
        Return characterID
    End Method

    Method GetName:String() Abstract
    Method GetHP:Int() Abstract
End Type
