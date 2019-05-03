SuperStrict

Import "CTCharacter.bmx"

Type CTLlama Extends CTCharacter
    Public
    Method New(name:String)
        Super.New(name)

        Self.hp = 200
        Self.hitChance = 40.0
        Self.damage = (100.0 / 6)
    End Method
End Type
