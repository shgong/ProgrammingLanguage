# Summary

## 1. Introduction to Subtyping

- Static types for functional program
  - like ML
  - prevent errors like treating a number as a function.
  - use parametric polymorphism, also known as generics.
- Static types for OOP program
  - like Java
  - prevent method/field missing errors
  - use subtype polymorphism, also known as subtyping
- Java is a bit too complicated, use small language like records instead

## 2. A Made-Up Language of Records

```
// Expression
{f1=e1, f2=e2, ..., fn=en}
e.f
e1.f = e2

// Type System
{f1:t1, f2:t2, ..., fn:tn}
{foo: {x: real, y: real}, bar: string, baz: string}

// code
fun distToOrigin (p:{x:real,y:real}) =
  Math.sqrt(p.x*p.x + p.y*p.y)

val pythag : {x:real,y:real} = {x=3.0, y=4.0}

val five : real = distToOrigin(pythag)
```


## 3. Wanting Subtyping

Following code will not type check

```
fun distToOrigin (p:{x:real,y:real}) =
  Math.sqrt(p.x*p.x + p.y*p.y)

val c : {x:real,y:real,color:string} = {x=3.0, y=4.0, color="green"}
val five : real = distToOrigin(c)
```

- The type of c has color field in it, not as expected (only x, y fields)
- as c has type `{x: real, y:real, color:string}`, it can also have `{x:real, y:real}`
- the subtype have more information

## 4. The Subtyping Relation

- type system
  - subtype: `t1 <: t2`
  - if e has type t1 and `t1 <: t2`, then e also has t2

- this approach is good langauge engineering
  - separted idea of subtyping into single binary relation
  - our goal is still preventing field-missing errors

- some good subtyping rules
  - `width` sybtyping: a supertype can have subset of fields with the same types
  - `permutation` subtyping: supertype can have same set of fields in different order
  - transitivity: if `t1 <: t2` and `t2 <: t3`, then `t1 <: t3`
  - reflexivity: `t <: t`


## 5. Depth Subtyping: A Bad Idea With Mutation

- Above rule can let us drop fields or reorder fields
- But no way for supertype to have a field with different type than subtype
  - we can drop r, drop center, reorder
  - but can not reach into fields
  - maybe we need more depth

```
fun circleY (c: {center: {x: real, y:real}, r: real}) = c.center.y
val sphere: {center: {x: real, y:real, z: real}, r: real} = {center={x:3,y=4,z=5}, r=1}
val _ = circleY(sphere)
```

- What to do
- Can we introduce depth rule?
  - if `ta <: tb`
  - then `{f1:ta, f2:t2} <: {f1:tb, f2:t2}`
- No, will break our type system

```
fun setToOrigin (c: {center: {x:real, y:real}, r:real}) = c.center = {x=0, y=0}
// won't setToOrigin when there are three fields
```

- DEPTH SUBTYPING is UNSOUND !!!


### you can only have 2 of 3 features

- setting a field
- letting depth subtyping change type of a field
- having a type system prevent field-missing errors


## 6. Problem with Java/C# Array Subtyping


## Function Subtyping

## Subtyping for OOP

### Covariant self/this


## Generics Versus Subtyping

## Bounded Polymorphism

### Additional Java-Specific Bounded Polymorphism
