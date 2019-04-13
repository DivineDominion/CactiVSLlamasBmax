SuperStrict

Import "../Army/CTCharacter.bmx"
Import "../View/CTRect.bmx"

Type CTToken Abstract
    Method DrawOnBattlefield(rect:CTRect) Abstract
    Method GetCharacter:CTCharacter() Abstract
End Type
