SuperStrict

Import "../Army/CTCharacter.bmx"

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


    '#Region Character animation
    Public
    Method SetCharacterAnimator(animator:CTCharacterAnimator)
        Self.character.SetAnimator(animator)
    End Method
    '#End Region
End Type
