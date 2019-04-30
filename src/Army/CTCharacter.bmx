SuperStrict

Import "../Event.bmx"
Import "../Util/CTInteger.bmx"

Type CTCharacter Abstract
    '#Region Base Character ID
    Private
    Global nextCharacterID:Int = 1
    Field characterID:Int

    Method New()
        Self.characterID = CTCharacter.nextCharacterID
        CTCharacter.nextCharacterID :+ 1
    End Method

    Public
    Method GetID:Int()
        Return characterID
    End Method
    '#End Region


    '#Region Name
    Protected
    Field name:String

    Method New(name:String)
        New()
        Assert name And name.length > 0 Else "CTCharacter requires name"
        Self.name = name
    End Method

    Public
    Method GetName:String()
        Return Self.name
    End Method
    '#End Region


    '#Region Stats
    Protected
    Field maxHP%, hp%
    Field hitChance#, damage%

    Public
    Method GetHP:Int()
        Return Self.hp
    End Method

    Method GetMaxHP:Int()
        Return Self.maxHP
    End Method

    Method GetDamage:Int()
        Return Self.damage
    End Method
    '#End Region

    Method TakeDamage(damage:Int)
        If Self.hp <= 0 Then Return

        Self.hp :- damage
        Fire("CharacterDidTakeDamage", Self, New CTInteger(damage))
        If Self.hp <= 0
            Fire("CharacterDidDie", Self)
            Self.hp = 0
        End If
    End Method
End Type
