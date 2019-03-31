SuperStrict

Type CTMutableArray<T> Implements IIterable<T>
    Private
    Field base:T[]

    Public
    Method New()
        base = []
    End Method

    Function Create:CTMutableArray<T>(base:T[])
        Local result:CTMutableArray<T> = New CTMutableArray<T>()
        result.base = base
        Return result
    End Function

    Rem
    bbdoc: Shallow copy of the collection.
    End Rem
    Method ToArray:T[]()
        Local result:T[Count()]
        ArrayCopy(base, 0, result, 0, Count())
        Return result
    End Method

    Method Count:Int()
        Return base.length
    End Method

    Method GetElementAt:T(index:Int)
        Return base[index]
    End Method

    Method Append(element:T)
        ' Resize array
        Local oldBase:T[] = Self.base
        Local newBase:T[] = New T[oldBase.length + 1]
        ArrayCopy(oldBase, 0, newBase, 0, oldBase.length)
        ' Append new element
        newBase[newBase.length - 1] = element
        Self.base = newBase
    End Method

    Method DeleteElement:Int(index:Int)
        If index < 0 Or Count() = 0 Or index >= Count()
            Throw New TNoSuchElementException
        End If
        ' Resize array
        Local oldBase:T[] = Self.base
        Local newBase:T[] = New T[oldBase.length - 1]
        ArrayCopy(oldBase, 0, newBase, 0, index + 1)
        ArrayCopy(oldBase, index + 1, newBase, index, (oldBase.length - index -1))
        Self.base = newBase
    End Method

    Method Iterator:CTMutableArrayIterator<T>()
        Return New CTMutableArrayIterator<T>(Self)
    End Method
End Type

Type CTMutableArrayIterator<E> Implements IIterator<E>
    ' Is `-1` unless you iterate with `NextElement()`,
    ' then it denotes the last iterated-over index.
    Field _lastIteratedIndex:Int = -1
    Field _index:Int = 0
    Field _coll:CTMutableArray<E>

    Method New(array:CTMutableArray<E>)
        Self._coll = array
    End Method

    Method HasNext:Int()
        Return _index < _coll.Count()
    End Method

    Method NextElement:E()
        If Not HasNext() Then
            Throw New TNoSuchElementException
        End If
        Local elem:E = _coll.GetElementAt(_index)
        _lastIteratedIndex = _index
        _index :+ 1
        Return elem
    End Method

    Method Remove()
        If _lastIteratedIndex < 0 Then
            Throw New TIllegalStateException
        End If
        _coll.DeleteElement(_lastIteratedIndex)
    End Method
End Type
