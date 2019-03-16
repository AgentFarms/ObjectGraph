# ObjectGraph

Simple object graph and it's manipulation library.

Core concept is a graph structure where nodes are objects and edges are
labelled references between objects. We call the label type a `slot`. Slots are
expected to be unique within an object although they might not be unique within
the graph. Edges are uniquely identified by a tuple `(object, slot)`.

Definition: `ObjectGraph<Reference:Hashable, State, Slot:Hashable>`.

Example:

```
    let graph = ObjectGraph<Int,Int,String>
    
    graph.insert(10, state: 0)
    graph.insert(20, state: 0)
    graph.insert(30, state: 0)
    graph.insert(40, state: 0)

    graph.connect(10, to: 20, at: "next")
    graph.connect(20, to: 30, at: "next")
    graph.connect(30, to: 40, at: "next")
```

----

License: MIT
Author: Stefan Urbanek <stefan.urbanek@gmail.com>

