---
layout: page
title: Type Aliases in Rust
description: Naming your complex types that stand for distinct concepts is a great way to simplify your Rust code.
tags:
 - rust
 - readability
 - types
---

I always forget about type aliases when I'm writing Rust code--mostly I get caught up in making it work mechanically and making the compiler happy and forget about readability.  But yesterday, I was working through Advent of Code Day 3 challenge, and I remembered them.  Just to see if they helped, I sprinkled them into my code, and I was *shocked* at how much better I felt about reading through what I had done.

 > Better readability, better self-documentation, less static to hold in mental memory at once.

Here's a snippet of the code before the transformation:

```rust
fn parse_input() -> (Vec<Coordinate>, Vec<Coordinate>) {
    let text = fs::read_to_string("data/day3.txt").unwrap();
    let lines: Vec<&str> = text.split("\n").collect();
    let mut wires = lines.into_iter().map(build_moves).map(make_wire);
    (wires.next().unwrap(), wires.next().unwrap())
}

/// Build a Wire out of relative Moves
fn make_wire(moves: Vec<Coordinate>) -> Vec<Coordinate> {
    let mut current = Coordinate { x: 0, y: 0 };
    let mut results: Wire = Vec::new();

    for step in moves {
        current = step + current;
        results.push(current);
    }

    results
}

// ...
```

Lots of Vectors full of Coordinates right?  And some are global coordinates, and some are lists of relative steps from one coordinate to the next, so they're not *conceptually* the same "type" of `Vec<Coordinate>`.  Messy, right?

Here's what it looks like after I add in my type aliases:

```rust
/// A Wire is a chain of coordinates that are electrically connected
type Wire = Vec<Coordinate>;

/// Moves are an ordered list of delta moves to make to form a wire
type Moves = Vec<Coordinate>;


fn parse_input() -> (Wire, Wire) {
    let text = fs::read_to_string("data/day3.txt").unwrap();
    let lines: Vec<&str> = text.split("\n").collect();
    let mut wires = lines.into_iter().map(build_moves).map(make_wire);
    (wires.next().unwrap(), wires.next().unwrap())
}

/// Build a Wire out of relative Moves
fn make_wire(moves: Moves) -> Wire {
    let mut current = Coordinate { x: 0, y: 0 };
    let mut results: Wire = Vec::new();

    for step in moves {
        current = step + current;
        results.push(current);
    }

    results
}

// ...
```

Now, even though `Wire` and `Moves` are made up of the same ingredients, they are separated conceptually for our brains to process, and our intent is documented much better.

This is my *fourth* attempt at learning Rust, and it's certainly feeling quite a bit better than any time before.  So, yay for improvement!
