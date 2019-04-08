SuperStrict

Import "CTCharacter.bmx"

Type CTCactus Implements CTCharacter
    Private
    Field name:String
    Field hp%
    Field hitChance#, damage#

    Method New()
        Self.hp = 100
        Self.hitChance = 80.0
        ' Make opponent survive more than 1 round of 6 concentrated hits
        Self.damage = (100.0 / 9)
    End Method

    Public
    Method New(name:String)
        New()
        Assert name And name.length > 0 Else "CTCactus requires name"
        Self.name = name
    End Method


    '#Region CTCharacter
    Method GetHP:Int()
        Return Self.hp
    End Method

    Method GetName:String()
        Return Self.name
    End Method
    '#End Region
End Type
