SuperStrict

Import "CTOperation.bmx"

Rem
Use instead of `Null` when creating optional operations. Can still be enqueued
and finishes immediately. This way, you don't need Null checks.
End Rem
Type CTNullOperation Extends CTOperation Final
    Method Main:Int()
        Return FINISHED
    End Method
End Type
