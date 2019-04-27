# Class hierarchy

The reusable controllers are designed to present a battlefield on screen. Pass a `CTBattlefield` model to a `CTBattlefieldWindowController`. Then you can use the window controller to select things on the battlefield's visual representation.

## Model

- `CTBattlefield` is the 2D map representations of fighters in the field
- `CTToken` is the representation of a character on the battlefield
    1. `CTCactusToken` is a concrete token for a cactus character
- `CTTokenPosition` is the X/Y position of `CTToken`s on the battlefield map

## View

- `CTBattlefieldView` is the view that draws all `CTBattlefield` contents
- `CTTokenView` draws a `CTToken` on screen inside of the battlefield
- `CTBattlefieldSelectionView` is an animatable and drawable selection around tokens

## Controller

- `CTBattlefieldSelectionController` is an abstract base type to move a `CTBattlefieldSelectionView` selector on the battlefield. It comes in these variants:
    1. `CTTokenSelectionController` to pass tokens from the battlefield to its delegate
    2. `CTTokenPositionSelectionController` to select any tile on the battlefield, occupied or no
- `CTBattlefieldViewController` groups interaction with the `CTBattlefieldSelectionController` instances
- `CTBattlefieldWindowController` displays the actual battlefield in a frame and passes on selection requests to `CTBattlefieldViewController`
