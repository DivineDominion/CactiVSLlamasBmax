SuperStrict

Import "CTOperation.bmx"

Type CTOperationQueue
    Public
    Function Main:CTOperationQueue()
        Return mainQueue
    End Function

    Function OperationDidComplete:Int(operation:CTOperation)
        Main().operationQueue.Remove(operation)
    End Function

    Function Enqueue(operations:CTOperation[])
        For Local operation:CTOperation = EachIn operations
            Enqueue(operation)
        Next
    End Function

    Function Enqueue(operation:CTOperation)
        Main().operationQueue.AddLast(operation)
    End Function

    Private
    Field operationQueue:TList = New TList

    Public
    Method Update(delta:Float)
        For Local operation:CTOperation = EachIn operationQueue
            If operation.IsReady() Then operation.Execute(CTOperationQueue.OperationDidComplete)
        Next
    End Method
End Type

Private
Global mainQueue:CTOperationQueue = New CTOperationQueue()
