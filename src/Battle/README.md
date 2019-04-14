# Class hierarchy

## Model

- `CTBattlefield` is the 2D representations of fighters in the field;
- `CTToken` is the representation of a character on the battlefield
- `CTTokenPosition` is the X/Y position of `CTToken`s

## View

- `CTBattlefieldView` is the view that draws `CTToken`s of the `CTBattlefield`
- `CTTokenSelectionView` is an animatable and drawable selection around tokens

## Controller

- `CTTokenSelectionController` moves a `CTTokenSelectionView`
- `CTBattlefieldViewController` groups interaction with the battlefield components
- `CTBattlefieldWindowController` displays the actual battlefield in a frame and tears down sub-components when the window is closed
- `CTBattle` is the highest-level service object that 
    - manages transitions between battle scene interactions, 
    - manages the `CTBattlefieldWindowController`

