# How does attacking work?

To understand how battle mechanics work, take inflicting physical damage for example, implemented in `CTTackleAction`. 

The underlying use case is this:

> As a _player_, I want to order _my fighter_ to _tackle_ an _enemy_ so I can _inflict damage_.

From this follows:

- The player, that's you, owns fighters.
- You can command fighters what to do.
- The "tackle" action inflicts damage on an enemy.

Let's translate this into the objects you find here:

- `CTPlayer` has a `CTArmy` with `CTCharacter`s; from these, you can select the fighter. That's the source of the action.
- `CTTackleAction` is the command, and an enemy fighter is the target.
- `CTDamageEffect` represents the damage inflicted.

## Implementation of actions and effects and UI

The concrete implementation works with abstract interfaces. For example, how do you, the player in front of the computer, select the action? Via an action menu. So the action needs a label. The action also needs to know if its effect needs a target, and tell "the game" that you, the player, need to pick a target. (Unless it's random or automatic, which it isn't in this game.) `CTActionable` is the interface for this stuff. 

If you take a look at how things are displayed on screen, the `CTBattlefieldView` lays out all characters on the battle map. If you pick an action, a naive approach would be to display a new map to select a target enemy. But you could use the existing battlefield interaction UI instead. It doesn't make sense to let e.g. `CTTackleAction` know how to control the battlefield UI. Instead, you want to reduce the knowledge of an action to a bare minimum. Here, it only knows that it needs a target to work, and how to produce its damage effect.

This stuff, selecting a target and applying damage, is handled by an _action driver_: It is represented by the `CTDrivesActions` interface and implemented by `CTBattle`. The action driver takes care of executing the steps necessary to make an action _happen_ and realize its effects. Selecting a target works by commanding the driver to `SelectEffectTargetForAction(CTTargetableActionable)`. The tackle action passes itself in as the parameter to get notified by the driver when a target is selected. 

Here's some code to illustrate the point:

    Method ExecuteInDriver(driver:CTDrivesActions)
        driver.SelectEffectTargetForAction(Self)
    End Method

    Method ExecuteInDriverWithTarget(driver:CTDrivesActions, target:CTEffectTarget)
        If Not target Then Return
        Local effect:CTTargetedEffect = New CTDamageEffect(123)
        driver.ApplyEffectToTarget(effect, target)
    End Method

Now the action driver could be anything. It could be an aspect of the `CTBattlefieldView` itself. It could be something totally different. Either way, the _action_ doesn't care. It only cares for the `SelectEffectTarget` to be executed. If a target is selected, it then creates the damage effect and tells the driver to apply the damage effect. It doesn't care how. As far as the action is concerned, the target itself doesn't need to know how to receive damage. It's only relevant that the target picked by you, the player, can be combined with the effect and then passed on.

That's all an action does. This makes creating new actions very simple. There are a surprising amount of different types involved, of course, but that's the price for flexibility: instead of hard-coding everything into one place, you create many different places and interfaces and adapters that can be freely recombined.

To summarize:

- `CTTackleAction` implements `CTActionable`; that common abstraction makes it executable in turns of the battle. It also implements the `CTTargetableActionable` trait so the driver can pass the tackled target back,
- `ExecuteInDriver(driver)` and `ExecuteInDriverWithTarget(driver, target)` represents the steps to execute the action. 
- `GetLabel()` makes the action displayable in an action picker UI.
- Actions should know as little as possible about the rest of the game's objects. This means actions are decoupled from the rest, which in turns means you can change how actions work without breaking a lot of the rest of the game. In this case, the action knows these things: 
    1. The `CTDamageEffect` that's applied to a target, and
    2. the `CTDrivesActions` service that takes care of selecting a target and then applying the damage effect.
- `CTDrivesActions` is the "output port" of an action that tells the game to execute effects; it also remote controls the battlefield UI a bit when you select a target enemy.

    