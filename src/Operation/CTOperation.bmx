SuperStrict

Rem
Single-shot operation: use once, then throw away.
For concurrent operations
End Rem
Type CTOperation Abstract
    '#Region Operation State
    Private
    Const STATE_INITIAL:Int = 0
    Const STATE_EXECUTING:Int = 10
    Const STATE_CANCELLED:Int = 50
    Const STATE_FINISHED:Int = 100
    Field _state:Int = STATE_INITIAL

    Protected
    Field completion:Int(operation:CTOperation)

    Rem
    Call in subclasses if your operation is concurrent/non-blocking and you need
    to mark it as finished.
    End Rem
    Method Finish()
        If _state = STATE_CANCELLED Then Throw "Finish called on cancelled operation"
        If _state = STATE_FINISHED Then Throw "Finish called on already finished operation"
        _state = STATE_FINISHED
        completion(Self)
        completion = Null
    End Method

    Public
    Method IsReady:Int() Final
        If _state <> STATE_INITIAL Then Return False
        Return DependenciesHaveCompleted()
    End Method

    Method IsExecuting:Int() Final
        Return _state = STATE_EXECUTING
    End Method

    Method IsCancelled:Int() Final
        Return _state = STATE_CANCELLED
    End Method

    Method IsFinished:Int() Final
        Return _state = STATE_FINISHED
    End Method

    Method Execute(completion:Int(operation:CTOperation))
        If Not IsReady() Then Return

        _state = STATE_EXECUTING
        Self.completion = completion
        If Self.Main() = FINISHED Then Self.Finish()
    End Method

    Const FINISHED:Int = False
    Const ONGOING:Int = True

    Rem
    Override #Main to implement the operation. Concurrent/non-blocking operations
    need to call #Finish when done and return ONGOING.
    Defaulting to False makes it easier to override.
    returns: ONGOING if the operation is still running and completes later, FINISHED if the operation is completed.
    End Rem
    Method Main:Int()
        Return FINISHED
    End Method
    '#End Region


    '#Region Sequence management
    Private
    Field dependencies:TList = New TList()

    Public
    Method AddDependency(other:CTOperation)
        If _state <> STATE_INITIAL Then Throw "Adding dependencies to running/completed operations not permitted"
        dependencies.AddLast(other)
    End Method

    Method RemoveDependency(other:CTOperation)
        If _state <> STATE_INITIAL Then Throw "Removing dependencies to running/completed operations not permitted"
        dependencies.Remove(other)
    End Method

    Method DependenciesHaveCompleted:Int()
        For Local dependency:CTOperation = EachIn Self.dependencies
            If dependency.IsReady() Or dependency.IsExecuting() Then Return False
        Next
        Return True
    End Method
    '#End Region
End Type
