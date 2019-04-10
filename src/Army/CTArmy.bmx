SuperStrict

Import "CTCharacter.bmx"

Type CTArmy
    Method New(); End Method

    Public
    Field ReadOnly characters:CTCharacter[]

    Method New(characters:CTCharacter[])
        Self.characters = characters
    End Method
End Type
