
# Generics in Go

Generics, introduced in Go 1.18, provide a way to write flexible, reusable
code that works with any data type while maintaining type safety.  

They allow you to write functions, types, and methods that can operate on
many different data types without sacrificing Go's performance and type safety.

## Table of Contents
* [What Are Generics?](#what-are-generics?) 
* [Key Concepts](#key-concepts) 
    * [Type Parameters](#type-parameters) 
    * [Type Constraints](#type-constraints) 
* [Basic Syntax](#basic-syntax) 
    * [Defining a Generic Function](#defining-a-generic-function) 
    * [Defining a Generic Type](#defining-a-generic-type) 
    * [Using Type Constraints](#using-type-constraints) 
* [Using Generics](#using-generics) 
    * [Instantiating a Generic Type](#instantiating-a-generic-type) 
    * [Calling a Generic Function](#calling-a-generic-function) 
    * [Best Practices](#best-practices) 
    * [Advanced Topics](#advanced-topics) 
* [Generics Explained with a Kitchen Analogy](#generics-explained-with-a-kitchen-analogy) 
    * [Type Parameters: The Adjustable Knife](#type-parameters:-the-adjustable-knife) 
    * [Type Constraints: The Safety Lock on Your Adjustable Knife](#type-constraints:-the-safety-lock-on-your-adjustable-knife) 
    * [Using Generics: Preparing a Specific Dish](#using-generics:-preparing-a-specific-dish) 
    * [Summary for Absolute Beginners with Examples](#summary-for-absolute-beginners-with-examples) 

## What Are Generics?

Generics enable you to write code that abstracts over types.  

Before generics, Go developers used interfaces and type assertions for 
similar purposes, but these approaches lacked type safety at compile time
and required additional runtime checks.
 
## Key Concepts

### Type Parameters

Type parameters define one or more generic types for a function, type, or method.  
They are specified using square brackets `[]` and give the function or type
the flexibility to operate on different data types.

* Technical
    * Type parameters are placeholders for any type, specified
      using `[]` alongside function, type, or method definitions.
* Plain English
    * Imagine you're writing a recipe that could use any ingredient.
    * The ingredient is a "type parameter"; whether it's chicken, tofu, or
      vegetables, the recipe (function) works the same.

When you define a function with a generic type parameter in Go, you
are defining a type to be used in the function's parameters 
(and possibly its return type),
not the type that can call the function.


### Type Constraints

You define type constraints by creating an interface.  

Type constraints specify what operations can be performed on the type 
parameters or which methods they must have.  
If no constraint is specified, the `any` type is used, allowing any type to be passed.

* Technical: Constraints are rules specifying the operations possible on
  type parameters, defined via interfaces.
* Plain English: If your recipe requires the ingredient to be chopped, the "choppable"
  ingredient is a constraint. Only items you can chop fit this recipe's requirement.


## Basic Syntax

### Defining a Generic Function
```go
func Print[T any](value T) {
    fmt.Println(value)
}
```
* `T` is a type parameter that can be `any` type.  
    * Then it's used in the function's parameter: `(value T)`.  
* `Print` is a generic function that prints a value of any type.


### Defining a Generic Type
```go
type Stack[T any] struct {
    elements []T
}
```
* `Stack` is a generic type that can hold elements of any type.
* The `Stack` type has a field of type `[]T` where `T` is the type parameter.  



### Using Type Constraints
```go
type Adder[T any] interface {
    Add(a, b T) T
}
 
func Sum[T Adder[T]](a, b T) T {
    return a.Add(b)
}
```
* `Adder` is an interface that specifies a type constraint.  
* `Sum` is a generic function that works with any type `T` that
  satisfies the `Adder` interface.

* Note that `Sum` is not a method. It's a generic function that works
  with any `Adder` type.  



## Using Generics


### Instantiating a Generic Type
```go
s := Stack[int]{}
s.Push(1)
```
You instantiate a generic type by providing a specific type argument in place
of the type parameter.


### Calling a Generic Function
```go
func Print[T any](value T) {
    fmt.Println(value)
}
Print("Hello, Generics!") // T is inferred to be string
Print(123)                // T is inferred to be int
```
Type inference allows you to call a generic function without explicitly 
specifying the type parameter.


---


### Best Practices

* Use Descriptive Type Parameter Names: 
    * Instead of single letters, consider using more descriptive names, especially
      when the type parameter has a specific role or constraint.
    
* Minimize Constraints
    * Use constraints only when necessary.  
    * Over-constraining can reduce the flexibility and reusability of your generic code.
    
* Test with Diverse Types
    * Ensure your generic code works as expected with various 
      types, especially when constraints are involved.

### Advanced Topics

* Type Sets: Type sets define the set of types that a type parameter can take.  
    * They are implicitly defined by interfaces but can involve more complex rules, especially with union types and methods.
    
* Methods on Generic Types: You can define methods on generic types.  
    * However, the method receiver cannot be a type parameter.
    
* Generic Methods: Introduced in Go 1.18, generic methods allow methods themselves to have type parameters.

---------------------------------------------------------------------------------------

## Generics Explained with a Kitchen Analogy

Imagine you're a chef with a special set of adjustable kitchen tools.  
 
These tools can adapt to handle different ingredients, making your job more
efficient and your kitchen less cluttered.

### Type Parameters: The Adjustable Knife

Analogy: You have an adjustable knife that can be set to slice various ingredients
         finely or coarsely, depending on the dish you're preparing.

Programming Example:

Let's say you have a list of ingredients, like fruits, and you want to prepare a fruit salad. You need a function that can "slice" any fruit.

* Generic Function without Generics
    * You would need a different knife (function) for apples, bananas, oranges, etc.
* With Generics
    * You have one adjustable knife (a generic function) that can handle all types of fruits.

```go
// A generic function in Go, acting as an adjustable knife.
func Slice[T any](ingredient T) []T {
    // This function "slices" any type of ingredient you give it.
    return []T{ingredient} // Simplified example; returns a "sliced" ingredient.
}

// Using the generic Slice function.
Slice("apple") // Here, T is inferred to be a string representing an apple.
```

### Type Constraints: The Safety Lock on Your Adjustable Knife

Analogy: Your adjustable knife has a safety lock that prevents it from being used
         to slice things it shouldn't, like bread with a fish slicer setting.

Programming Example:

Suppose you want to ensure your `Slice` function only works with types that
can actually be "sliced" in a metaphorical sense, like fruits but not soup.

```go
type Fruit interface {
    Peel() string
    Slice() []string
}

// A generic function that now requires the ingredient to satisfy the Fruit interface.
func Slice[T Fruit](ingredient T) []string {
    return ingredient.Slice()
}
```

In this example, `T` must be a type that has `Peel` and `Slice` methods, similar
to how the safety lock ensures the knife is only used for appropriate ingredients.

### Using Generics: Preparing a Specific Dish

Analogy: Deciding to make an apple smoothie, you adjust your blender to the "apple" setting and proceed.

Programming Example:

You have a generic `Blend` function, and you decide to use it with apples.

```go
// Blend function that can blend any fruit into a smoothie.
func Blend[Fruit any](fruit Fruit) string {
    // Imagine blending the fruit.
    return "Smoothie made with " + fmt.Sprint(fruit)
}

// Making an apple smoothie.
appleSmoothie := Blend("apple") // Here, the "apple" is a string, but imagine it's an apple type.
fmt.Println(appleSmoothie)
```

In this analogy, the `Blend` function is your blender, adaptable for any fruit.  
The "apple" setting is you choosing to call `Blend` with an "apple" as its argument.

### Summary for Absolute Beginners with Examples

Generics in Go allow you to write flexible, reusable code, similar to having an adjustable kitchen tool.  
They enable you to:

* Write less repetitive code: Just like using one adjustable knife for all fruits, you write one function that works with many types.
* Maintain type safety: The safety lock analogy ensures you only slice what's sliceable, just as type constraints ensure your generics work only with appropriate types.
* Adapt code for specific needs easily: Choosing to make an apple smoothie with an adjustable blender is like using a generic function with a specific type.

Understanding and using generics help make your Go code more adaptable and efficient, just as adjustable tools make your cooking more versatile and enjoyable.
