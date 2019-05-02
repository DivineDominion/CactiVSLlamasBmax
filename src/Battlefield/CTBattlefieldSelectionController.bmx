SuperStrict

Import "../View/CTController.bmx"
Import "CTBattlefieldSelectionView.bmx"
Import "CTTokenPosition.bmx"
Import "CTBattlefieldView.bmx"
Import "CTBattlefield.bmx" ' for BATTLEFIELD_ROWS and BATTLEFIELD_COLUMNS

Rem
Base type for selecting things on the battlefield. Concrete subclasses
filter either by position, or by token placed on the battlefield.
End Rem
Type CTBattlefieldSelectionController Extends CTController Abstract
    Private
    Field selectionView:CTBattlefieldSelectionView
    Field _selectedTokenPosition:CTTokenPosition

    Method New(); End Method

    Public
    Method New(initialTokenPosition:CTTokenPosition = Null)
        ' FIXME: use extra init method from constructor because of: https://github.com/bmx-ng/bcc/issues/417
        Initialize(initialTokenPosition)
    End Method

    Method Initialize(initialTokenPosition:CTTokenPosition)
        _selectedTokenPosition = initialTokenPosition
        If Not _selectedTokenPosition Then _selectedTokenPosition = CTTokenPosition.Origin()

        Self.selectionView = New CTBattlefieldSelectionView()
        Self.selectionView.keyInterpreterDelegate = Self

        UpdateTokenHighlighter()
    End Method

    Method SelectedTokenPosition:CTTokenPosition()
        Return _selectedTokenPosition
    End Method


    '#Region CTController
    Public
    Method View:CTView()
        Return Self.selectionView
    End Method

    Method TearDown()
        Super.TearDown()
    End Method
    '#End Region


    '#Region CTKeyInterpreter
    Public
    Method MoveUp()
        _selectedTokenPosition = _selectedTokenPosition.MovedUp(BATTLEFIELD_ROWS)
        UpdateTokenHighlighter()
    End Method

    Method MoveDown()
        _selectedTokenPosition = _selectedTokenPosition.MovedDown(BATTLEFIELD_ROWS)
        UpdateTokenHighlighter()
    End Method

    Method MoveLeft()
        _selectedTokenPosition = _selectedTokenPosition.MovedLeft(BATTLEFIELD_COLUMNS)
        UpdateTokenHighlighter()
    End Method

    Method MoveRight()
        _selectedTokenPosition = _selectedTokenPosition.MovedRight(BATTLEFIELD_COLUMNS)
        UpdateTokenHighlighter()
    End Method

    Private
    Method UpdateTokenHighlighter()
        ChangeHighlighterPosition()
        ResetHighlighterAnimation()
    End Method

    Method ChangeHighlighterPosition()
        Local newRect:CTRect = CTBattlefieldView.RectForTokenPosition(_selectedTokenPosition)
        Self.selectionView.bounds = newRect
    End Method

    Method ResetHighlighterAnimation()
        Self.selectionView.ResetAnimation()
    End Method
    '#End Region
End Type