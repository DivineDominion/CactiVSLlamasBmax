SuperStrict

Import "../Event.bmx"
Import "../Operation.bmx"
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

    Method IsAlive:Int()
        Return Self.hp > 0
    End Method

    Method GetDamage:Int()
        Return Self.damage
    End Method
    '#End Region


    '#Region Damage
    Public
    Method TakeDamage(damage:Int)
        If Not Self.IsAlive() Then Return

        ' Reduce HP
        Self.hp :- damage

        Local fireDidTakeDamage:CTOperation = New CTFireEventOperation("CharacterDidTakeDamage", Self, New CTInteger(damage))
        CTOperationQueue.Main().Enqueue(fireDidTakeDamage)


        ' Check for death
        If Self.IsAlive() Then Return

        Self.hp = 0 ' Avoid negative HP

        Local fireDidDie:CTOperation = New CTFireEventOperation("CharacterDidDie", Self)
        fireDidDie.AddDependency(fireDidTakeDamage)
        CTOperationQueue.Main().Enqueue(fireDidDie)
    End Method
    '#End Region
End Type
