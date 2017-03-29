# Functional Programming

- Avoid mutation in most case
- use function as values
- style close to math definition
- encourage recursive data structure
- idiom using laziness



## Lexical scope and dynamic scope

```ml
fun f g = let val x = 9 in g() end
val x = 7
fun h() = x+1
val y = f h
```

What value does y have
- lexical 8 (in ML)
    + allow to remove unused variables
    + essential in modularity
- dynamic 10
    + body of function h will see the local binding
    + if removed, will lead to undefined value

## infix
```
infix !>
fun x !> f = f x
fun sqrt_of_abs i = i !> abs !> Real.fromInt !> Math.sqrt
val sqrt_of_abs = Math.sqrt o Real.fromInt o abs
```

## curring
logician Haskell Curry

```
val sorted3 = fn x => fn y => fn z => z>=y andalso y>=x
val t1 = ((sorted3 7) 9) 11

fun sorted3_nicer x y z = z >= y andalso y>=x
(* syntax sugar for curried function *)
```

## Callbacks idiom

library take function to apply later
- key, mouse, data arrive
- accept private data in closures

## ADT

closure can implement adt
- put multiple functions in a record
- functions share same private data
- private data can be mutable
- OOP & FP similarity

## Surge of FP
- Where
    - C# LINQ (closure & type inference)
    - Java 8 (closure)
    - MapReduce (Avoid side-effect for fault tolerance)
- Why
    + Concise, elegant, productive
    + Javascript, python, ruby help break the ice
- What
    + Functional & dynamically typed: Racket
        * similar languages: Scheme, Lisp, Clojure
        * Racket have better IDE
    + Functional & statically typed: SML
        * similar languages: Ocaml & F#
    + OO & dynamically typed: Ruby
        * Python & Perl don't have full power of clojure
        * Javascript don't have classes
    + OO & Static typed: Java/C#/Scala
        * Smalltalk is less modern
    + More
        * Haskell: laziness, purity, type classes, monads
        * Prolog: unification and backtracking
