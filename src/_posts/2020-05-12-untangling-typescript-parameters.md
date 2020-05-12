---
layout: page
title: Untangling a Complicated TypeScript Function Signature
description: Destructuring, in-place object types, implicit void returns?  Let's work through this one together.
tags:
 - typescript
 - beginner
---

I accidentally started learning TypeScript today?  Oops.
Anyways, I came across this example code which wasn't particularly scary, but crinkled my brain a little as I tried to parse it.
I wanted to walk through it and explain all the different facets of it for anybody else who encounters something like this and is confused.

*(Caveat, it's from a book on Deno, so some of the TypeScript-isms will be only slightly different than your run-of-the-mill Node code.
But it shouldn't affect the example.
Also, it's from [Flavio](https://flaviocopes.com/).
He's got a ton of great JS-related articles, books, and other stuff too!)*

OK, so here's the code example:

```typescript
export const updateDog = async ({
  params,
  request,
  response,
}: {
  params: {
    name: string
  }
  request: any
  response: any
}) => {
  ... // code
}
```

All of that there is *just* the signature for this function, `updateDog`.
And it's a lot!
So let's break it down and simplify/verbosify it just a little bit to make it clear what's happening.

Let's rewind back to what a normal function signature looks like:

```typescript
function updateDog(parameter: ParameterType): ReturnType {
  // code
}
```

Cool?  Cool.  Now, to line this up with the mess above.

First, you'll notice that the complicated signature doesn't have a return type.
It just goes from the end of the parameter list (`})`) right into the function definition without a `: ReturnType`.
And that's OK!
Functions in Typescript that don't return anything and aren't expected to can leave off the `: ReturnType` and the correct one will be inferred.
Usually that's `void` for an unused undefined return, but soemtimes it could be something like `never` for a function that isn't supposed to return.

So, now we can see a little easier where the parameter stops and where the parameter type begins:

```typescript
export const updateDog = async ({params, request, response}: //...)
//                              ^-- this is the parameter-^ 
```

The parameter is actually *only one object!*
They're using a trick called destructuring to reach into the one object parameter and pull out the fields that are in it with the names "params", "request", and "response".

```typescript
const myStuff = {
  name: "Ryan",
  age: 28,
  favColor: "Blue",
}

const {name, age, favColor} = myStuff;
console.log(name)
// => Ryan
```

So, in the code example we're working on, we'll be able to use `params`, `request`, and `response` just like normal variables even though they came in bundled as one object.

Great!  Almost there.  Now that we've got those two bits parsed out, it's a little easier to see where the parameterType declaration is:

```typescript
// -- snip --
}: {
  params: {
    name: string 
  }
  resquest: any
  response: any
}) // -- snip --
```

When you're declaring the type for an object, you can do so by laying out the types for all of the fields that you expect.
It's a bit like a JSON schema specification.

If we're not too allergic to slightly more verbose code, we can clean up this type signature with some interfaces.

```typescript
interface Params {
  name: string;
}

interface UpdateParameters {
  params: Params;
  request: any;
  response: any;
}

export const updateDog = async ({params, request, response}: UpdateParameters) => {
  // code
}
```

Ah, now we start to see something resembling what we're used to.
And to go the whole way just to put a bow on it:

```typescript
export async function updateDog({params, request, response}: UpdateParameters) {
  // code
}
```

It's hard to find the balance between overly verbose and overly implicit, especially as you're learning the idioms of a new language.
Once you start to see the same "shortening" pattern over and over again, you can start incorporating it into your own code and your brain will fill in the details for you.

I've still got a lot to learn on the TypeScript front, and I want this article to be as accessible as possible for beginners, so if you spot anywhere I missed the mark, please let me know so I can get it fixed.

Happy coding!
