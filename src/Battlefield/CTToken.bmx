SuperStrict

Import "../Army/CTCharacter.bmx"

Rem
A CTCharacter view model for placement on the battlefield.
End Rem
Type CTToken 'Abstract
    ' Private ' FIXME: abstract field inheritance doesn't work, see <https://github.com/bmx-ng/bcc/issues/417>
    Field character:CTCharacter

    Method New(); End Method

    Public
    Method New(character:CTCharacter)
        Assert character Else "CTToken requires character"
        Self.character = character
    End Method

    Method GetName:String()
        Return Self.character.GetName()
    End Method

    Method GetCharacter:CTCharacter()
        Return Self.character
    End Method


    '#Region Character Death
    Private
    Field _characterIsAlive:Int = True

    Public
    Method OnCharacterDidDie(character:CTCharacter)
        If Self.character <> character Then Return
        Self._characterIsAlive = False
    End Method

    Method CharacterIsAlive:Int()
        Return _characterIsAlive
    End Method
    '#End Region
End Type
