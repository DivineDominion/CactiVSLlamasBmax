SuperStrict

Import "../Army/CTArmy.bmx"
Import "../Army/CTCactus.bmx"

Type CTPlayer
    Private
    Method New(); End Method

    Public
    Global cactusPlayer:CTPlayer = New CTPlayer("Cactii Power",..
        New CTArmy([..
            New CTCactus("Foo"),..
            New CTCactus("Bar"),..
            New CTCactus("Baz"),..
            New CTCactus("Fizz"),..
            New CTCactus("Buzz")]))
    Global llamaPlayer:CTPlayer = New CTPlayer("Llama Defense")

    Field name:String
    Field army:CTArmy

    Method New(name:String, army:CTArmy = Null)
        Self.name = name
        If Not army Then army = New CTArmy
        Self.army = army
    End Method
End Type
