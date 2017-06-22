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



## Depth Subtyping: A Bad Idea With Mutation

### Problem with Java/C# Array Subtyping


## Function Subtyping

## Subtyping for OOP

### Covariant self/this


## Generics Versus Subtyping

## Bounded Polymorphism

### Additional Java-Specific Bounded Polymorphism
