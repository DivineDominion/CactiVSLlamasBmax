SuperStrict

Import "CTCharacter.bmx"

Type CTCactus Extends CTCharacter
    Public
    Method New(name:String)
        Super.New(name)

        Self.maxHP = 100
        Self.hp = Self.maxHP

        Self.hitChance = 80.0
        ' Make opponent survive more than 1 round of 6 concentrated hits
        Self.damage = (100.0 / 9)
    End Method
End Type
