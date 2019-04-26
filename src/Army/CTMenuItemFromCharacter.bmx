SuperStrict

Import "CTCharacter.bmx"
Import "../View/CTMenuItem.bmx"

Function CTMenuItemFromCharacter:CTMenuItem(character:CTCharacter)
    Return New CTMenuItem(character.GetName(), character.GetID())
End Function
