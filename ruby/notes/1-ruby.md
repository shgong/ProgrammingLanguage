# Ruby

## Ruby Features

- Focus on OOP, dynamic typing, blocks and mixins
- Interesting Ruby features
  - pure object-oriented: all values are objects (Java has primitives)
  - class-based: every object is instance of class (Javascript isn't class based)
  - has mixins: reasonable compromise between multiple inheritance (C++) and interfaces (Java)
  - dynamic typed: allow calling any function, with runtime check
  - dynamic features: allow instance variable to be added and removed
  - convenient reflection: has method `class` and `method`
  - has blocks and closures: convenient high-order programming
  - scripting language: engineered towards making it easy to write short programs
- As OO language, ruby shares much with SmallTalk, adding some nice addition like mixins
- ruby is a large language
  - why not attitude
  - unlike ML/Racket/Smalltalk adhere strictly to traditional principles
    - define a small language with powerful features to build up
  - Ruby take opposite view
    - there are many ways to write if expression


## Rules of Class-Based OOP

- OOP
  - all values are reference to objects
  - given an object, code communicates with it by calling method
  - each object has its own private state
  - every object is an instance of a class
  - an object's class determine the object's behavior

## Objects, Classes, Methods, Variable

```ruby
class Foo  # className must be capitalized
  def m1 # can take any arguments
    ... # a method implicitly returns its last expression
  end

  def m2 (x,y)
  end

  def mn z
  end
end
```
