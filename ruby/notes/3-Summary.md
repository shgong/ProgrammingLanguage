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

- If record fields are mutable, depth subtyping is unsound
  - then how Java/C# treat Arrays?

```java
class Point { ... } // has fields double x, y
class ColorPoint extends Point { ... } // adds field String color
...

void m1(Point[] pt_arr) {
  pt_arr[0] = new Point(3,4);
}

String m2(int x) {
  ColorPoint[] cpt_arr = new ColorPoint[x];
  for(int i=0; i < x; i++)
    cpt_arr[i] = new ColorPoint(0,0,"green");
  m1(cpt_arr);
  return cpt_arr[0].color;
}
```

- Above code will type-check
- The call `m1(cpt_arr)` use depth subtyping with mutable
  - `cpt_arr[0].color` will read color field from non-existence
  - ???
- `ptr_arr[0] = new Point(3,4)` will raise exception if it is `ColorPoint[]`
  - ArrayStoreException
  - having the store raisse exception, so no other exception need run-time checks
  - object of type `ColorPoint[]` can only hold subtype, no supertype like `Point`


- Having run-time checks means
  - the type system is preventing fewer errors
  - require more care and testing
  - run-time cost of performing those checks
- WHY doing THIS
- for flexibility before generics are introduced
  - make type system simpler and less at the expense of statically checking less
  - a better way is combine generics with subtyping
  - see the bounded polymorphism

#### null in Java/C#

- value has no fields or methods
  - unlike nil in Ruby, it is not even an object
- instead, Java/C# allow null to have any object type, as though it defines every methods and all fields
  - which let every field access and method call includes a run-time check for NULL
  - leading to the NullPointerException
- WHY designed this way
  - convenient for initializing a field of type Foo
  - though you can use option type to do the same thing

## 7. Function Subtyping

- One function type is a subtype of another function type
  - as important for understanding how to safely override methods

- If
  - `t3 <: t1`
  - `t2 <: t4`
- then
  - `t1->t2 <: t3->t4`

- This rule, combined with reflexivity (t <: t)
  - let us use contravariant arguments, covariant results, or both

## 8. Subtyping for OOP

- an object is basically a record holding fields and methods
  - assume slots for methods are immutable
- sound subtyping for objects should:
  - a subtype can have extra fields
  - subtype can not have different type for a field, because fields are mutable
  - a subtype can have extra method
  - subtype can have a subtype for a method, method in subtype can have contravariant argument type and covariant result type


- Subtyping in Java/C# includes only
  - the subtyping explicitly stated via the subclass relationship
  - the interfaces that classes explicitly indicate they implement
- this is more restrictive than subtyping requires, because
  - it does not allow anything it should not
  - it soundly prevents field missing and method missing errors
- by
  - subclass can add fields but not remove
  - subclass can add methods but not remove
  - subclass can override method with covariant return type
  - subclass can implement more methods

- Classes and types are different things!
  - Java C# confuse them as a matter of convenience
  - class define object behavior
  - subclassing inhrits behavior, modify via override
  - type describes fields object have
  - subtyping is question of substitutability and what to flag as type error


## 9. Covariant self/this

- Java `this` and Ruby `self` is treated specially from typechecking perspective
- `this`
  - is passed as an extra explicit argument to a method
  - contravariant subtyping, `this` in a subclass could not have a subtype
- that's why coding up dynamic dispatch work less well in statically typed languages
  - you need special support in your type system for this


## 10. Generics Versus Subtyping

- Generics: parametric polymorphism [T]
- Subtyping: subtype polymorphism

### Generics good for?

1. There are functions combining other functions
2. There are functions operate over collections
```
val compose: ('b -> 'c) * ('a -> 'b) -> ('b -> 'c)

val length : 'a list -> int
val map : ('a -> 'b) -> 'a list -> 'b list
```

If we had to pick non-generic types for these functions, we would end up with significantly less code reuse.
Generics just says some argument can be anything, we reuse type variable to indicate when multiple things should be same type.

### Subtyping good for?

Subtyping is great for allowing code to be reused with extra information.

Geometry code over points works for colored-points.
But in ML, `distToOriginal` on a two field record won't type check on three field record


## 11. Bounded Polymorphism

- Combine the ideas to get even more code reuse and expressiveness

```
static <T extends Pt> List<T> inCircle(List<T> pts, Pt center, double radius) {
  List<T> result = new ArrayList<T>();
  for(T pt : pts)
    if(pt.distance(center) <= radius)
      result.add(pt);
    return result;
}
