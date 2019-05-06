SuperStrict

Import "CTCharacter.bmx"

Type CTLlama Extends CTCharacter
    Public
    Method New(name:String)
        Super.New(name)

        Self.maxHP = 200
        Self.hp = Self.maxHP

        Self.hitChance = 40.0
        Self.damage = (100.0 / 6)
    End Method
End Type
