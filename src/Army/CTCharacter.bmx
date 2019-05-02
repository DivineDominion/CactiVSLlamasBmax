SuperStrict

Import "../Event.bmx"
Import "../Operation.bmx"
Import "../Util/CTInteger.bmx"

Rem
Handles character animations on the battlefield and screen.
End Rem
Interface CTCharacterAnimator
    Method CharacterTakingDamageAnimationOperation:CTOperation(character:CTCharacter, damage:Int)
    Method CharacterDyingAnimationOperation:CTOperation(character:CTCharacter)
End Interface

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
        Self.hp = max(0, Self.hp - damage) ' Avoid negative HP

        Local animateDamage:CTOperation = TakingDamageAnimationOperation(damage)
        Local fireDidTakeDamage:CTOperation = New CTFireEventOperation("CharacterDidTakeDamage", Self, New CTInteger(damage))
        fireDidTakeDamage.AddDependency(animateDamage)
        CTOperationQueue.Main().Enqueue([animateDamage, fireDidTakeDamage])


        ' Check for death
        If Self.IsAlive() Then Return

        Local dyingAnimation:CTOperation = DyingAnimationOperation()
        Local fireDidDie:CTOperation = New CTFireEventOperation("CharacterDidDie", Self)
        dyingAnimation.AddDependency(fireDidTakeDamage)
        fireDidDie.AddDependency(dyingAnimation)
        CTOperationQueue.Main().Enqueue([dyingAnimation, fireDidDie])
    End Method
    '#End Region


    '#Region Character animations
    Private
    Field animator:CTCharacterAnimator = Null

    Public
    Method SetAnimator(animator:CTCharacterAnimator)
        Self.animator = animator
    End Method

    Method TakingDamageAnimationOperation:CTOperation(damage:Int)
        If Not Self.animator Then Return New CTNullOperation()
        Return Self.animator.CharacterTakingDamageAnimationOperation(Self, damage)
    End Method

    Method DyingAnimationOperation:CTOperation()
        If Not Self.animator Then Return New CTNullOperation()
        Return Self.animator.CharacterDyingAnimationOperation(Self)
    End Method
    '#End Method
End Type
