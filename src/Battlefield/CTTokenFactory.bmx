SuperStrict

Import "CTToken.bmx"
Import "CTCactusToken.bmx"
Import "../Army/CTCharacter.bmx"
Import "../Army/CTCactus.bmx"

Function CTTokenFromCharacter:CTToken(character:CTCharacter)
    Local typeId:TTypeId = TTypeId.ForObject(character)
    Local typeName:String = typeId.Name()
    If typeName = "CTCactus"
        Return New CTCactusToken(CTCactus(character))
    End If
    RuntimeError "Unexpected character type: " + typeName
End Function
