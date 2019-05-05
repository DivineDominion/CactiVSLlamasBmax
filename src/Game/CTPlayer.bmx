SuperStrict

Import "../Army/CTArmy.bmx"
Import "../Army/CTCactus.bmx"
Import "../Army/CTLlama.bmx"

Type CTPlayer
    Private
    Method New(); End Method

    Public
    Field name:String
    Field army:CTArmy

    Method New(name:String, army:CTArmy = Null)
        Self.name = name
        If Not army Then army = New CTArmy
        Self.army = army
    End Method


    '#Region Known players
    Public
    Global cactusPlayer:CTPlayer = New CTPlayer("Cacti Power",..
        New CTArmy([..
            New CTCactus("Fat 1"),..
            New CTCactus("Fat 2"),..
            New CTCactus("Needleful"),..
            New CTCactus("Giant 1"),..
            New CTCactus("Giant 2")..
        ]))
    Global llamaPlayer:CTPlayer = New CTPlayer("Llama Defense",..
        New CTArmy([..
            New CTLlama("Llama 1"),..
            New CTLlama("Llama 2"),..
            New CTLlama("Alpaca 1"),..
            New CTLlama("Alpaca 2"),..
            New CTLlama("Alpaca 3")..
        ]))

    Method Opponent:CTPlayer()
        If Self = CTPlayer.cactusPlayer Then Return CTPlayer.llamaPlayer
        If Self = CTPlayer.llamaPlayer  Then Return CTPlayer.cactusPlayer
        RuntimeError "Unknown player object"
    End Method
    '#End Region
End Type
