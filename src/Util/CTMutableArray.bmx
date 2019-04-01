SuperStrict

Const CT_NOT_FOUND:Int = -1

Type CTMutableArray
    Private
    Field base:Object[]

    Public
    Method New()
        base = []
    End Method

    Function Create:CTMutableArray(base:Object[])
        Local result:CTMutableArray = New CTMutableArray()
        result.base = base
        Return result
    End Function

    Rem
    bbdoc: Shallow copy of the collection.
    End Rem
    Method ToArray:Object[]()
        Local result:Object[Count()]
        ArrayCopy(base, 0, result, 0, Count())
        Return result
    End Method

    Method Count:Int()
        Return base.length
    End Method

    Method GetElementAt:Object(index:Int)
        Return base[index]
    End Method

    Method Append(element:Object)
        ' Resize array
        Local oldBase:Object[] = Self.base
        Local newBase:Object[] = New Object[oldBase.length + 1]
        ArrayCopy(oldBase, 0, newBase, 0, oldBase.length)
        ' Append new element
        newBase[newBase.length - 1] = element
        Self.base = newBase
    End Method

    Rem
    returns: CT_NOT_FOUND if not found, the index otherwise
    End Rem
    Method IndexOf:Int(element:Object)
        If Not element Then
            Throw New TNoSuchElementException
        End If

        For Local i:Int = 0 Until Count()
            If base[i] = element
                Return i
            End If
        Next
        Return CT_NOT_FOUND
    End Method

    Method RemoveFirst(element:Object)
        Local index:Int = IndexOf(element)
        If index = CT_NOT_FOUND
            Return
        End If
        RemoveElementAt(index)
    End Method

    Method RemoveElementAt:Object(index:Int)
        If index < 0 Or Count() = 0 Or index >= Count()
            Throw New TNoSuchElementException
        End If

        Local removedElement:Object = GetElementAt(index)

        ' Resize array
        Local oldBase:Object[] = Self.base
        Local newBase:Object[] = New Object[oldBase.length - 1]

        If index = Count() - 1
            ' Remove last
            ArrayCopy(oldBase, 0, newBase, 0, index)
        Else
            ' Remove from middle
            ArrayCopy(oldBase, 0, newBase, 0, index + 1)
            ArrayCopy(oldBase, index + 1, newBase, index, (oldBase.length - index - 1))
        End If

        Self.base = newBase

        Return removedElement
    End Method

    Method ObjectEnumerator:CTMutableArrayEnumerator()
        Return New CTMutableArrayEnumerator(ToArray())
    End Method
End Type

Type CTMutableArrayEnumerator
    Field _index:Int = 0
    Field _coll:Object[]

    Method New(array:Object[])
        Self._coll = array
    End Method

    Method HasNext:Int()
        Return _index < _coll.length
    End Method

    Method NextObject:Object()
        If Not HasNext() Then
            Throw New TNoSuchElementException
        End If
        Local elem:Object = _coll[_index]
        _index :+ 1
        Return elem
    End Method
End Type
