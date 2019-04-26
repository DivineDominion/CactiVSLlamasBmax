SuperStrict

Import "CTToken.bmx"
Import "../Army/CTCactus.bmx"

Type CTCactusToken Extends CTToken
    ' FIXME: abstract field inheritance doesn't work, see <https://github.com/bmx-ng/bcc/issues/417>
    ' Remove duplicate initializer when upgrading from bcc 0.99
    Method New(cactus:CTCactus)
        Assert cactus Else "CTToken requires character"
        Self.character = cactus
    End Method
End Type
