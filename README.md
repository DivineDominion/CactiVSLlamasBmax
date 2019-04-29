# Cacti VS Llamas - BlitzMax Prototype

A [BlitzMax NG](https://blitzmax.org/) prototype of a turn-based battle game.

Originated during [a Code Competition in the German BlitzBasic Forum](https://www.blitzforum.de/forum/viewtopic.php?t=41004).

## License

Copyright (c) 2019 Christian Tietze. Distributed under the MIT License.

## Style Guide

Knowing these might make reading the source code easier:

- Prefix types with `CT`
- CamelCase types and method names
- lowercase fields 
- UPPERCASE constants
- Favor bmax-ng  parameterized constructors over the `Create` factory method pattern
- Use `'#Region`/`'#End Region` to group cohesive parts of a type, e.g. interface implementations and start the group with an access modifier
- Use double newlines to visually separate blocks of code, e.g. regions
- Put public API methods at the top of a block, and their helper methods below them; that's how you read, from top to bottom

Example:

```bmx
SuperStrict

Type CTAmazingType
    Private
    Field aField:Int = 123
    
    Public
    Method New()
        ' ...
    End Method 
    
    
    '#Region Interface implementation
    Private
    Field privateFieldToImplementTheInterface:Int = 0
    
    Public
    Method MethodFromInterface()
        HelperMethod()
        ' ...
    End  Method
    
    Private
    Method HelperMethod()
        ' ...
    End Method
    '#End Region
End Type
```